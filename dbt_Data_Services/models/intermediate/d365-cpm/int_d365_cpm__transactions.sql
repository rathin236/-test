{{ config(materialized='table') }}

with gjae as (
    select
        ledgeraccount,
        iscredit,
        accountingcurrencyamount,
        transactioncurrencycode,
        text,
        transactioncurrencyamount,
        generaljournalentry,
        ledgerdimension,
        mainaccount
    from {{ ref('stg_d365__general_journal_account_entry') }}
    where ledgeraccount not like '210000%'
        and ledgeraccount not like '210030%'
        and ledgeraccount not like '210020%'
        and ledgeraccount not like '210010%'
    and ledgeraccount not like '120010%'
    and ledgeraccount not like '120000%'
    and ledgeraccount not like '120030%'
    and ledgeraccount not like '120020%'
),

gje as (
    select
        accountingdate,
        journalnumber,
        subledgervoucher,
        documentdate,
        recid,
        createdtransactionid,
        fiscalcalendarperiod,
        subledgervoucherdataareaid
    from {{ ref('stg_d365__general_journal_entry') }}
),

ljt as (
    select distinct
        voucher,
        company,
        exchrate,
        invoice,
        dataareaid,
        currencycode
    from {{ ref('stg_d365__ledger_journal_trans') }}
),

vt as (
    select * from {{ ref('int_d365_cpm__vend_trans') }}
),

vm as (
    select
        accountnum,
        party
    from {{ ref('stg_d365__vend_table') }}
),

ct as (
    select * from {{ ref('int_d365_cpm__cust_trans') }}
),

cm as (
    select
        accountnum,
        party
    from {{ ref('stg_d365__cust_table') }}
),

dpt as (
    select
        recid,
        name
    from {{ ref('stg_d365__dir_party_table') }}
),

asd as (
    select * from {{ ref('int_d365_cpm__account_segment_descriptions') }}
),

fcp as (
    select
        recid,
        name
    from {{ ref('stg_d365__fiscal_calendar_period') }}
),

final as (
    select
        '' as status,
        gje.accountingdate as transaction_date,
        fcp.name as period_number,
        gje.journalnumber as journal_entry_number,
        gje.subledgervoucher as voucher,
        gjae.ledgeraccount as account_number,
        --account segment numbers
        asd.mainaccountvalue as main_number,
        asd.costcentervalue as cost_centre,
        asd.departmentvalue as department,
        asd.divisionvalue as division,
        asd.locationvalue as location,
        asd.productlinevalue as product_line,
        asd.cashflowtypevalue as cash_flow,
        asd.companyrelationshipvalue as company_relationship,
        '' as account_description,
        --account segment descriptions
        asd.mainaccountdescription as main_account_description,
        asd.costcenterdescription as cost_centre_description,
        asd.departmentdescription as department_description,
        asd.divisiondescription as division_description,
        asd.locationdescription as location_description,
        asd.productlinedescription as product_line_description,
        asd.cashflowdescription as cash_flow_description,
        asd.companyrelationshipdescription as company_relationship_description,
        dpt.name as customer_vendor_name,
        --accounting currency debits and credits
        gje.documentdate as document_date,
        gjae.transactioncurrencycode as transaction_currency,
        --subledger details
        '' as canceled,
        gjae.text as text_description,
        upper(coalesce(ljt.dataareaid, gje.subledgervoucherdataareaid)) as company_name,
        case
            when gjae.iscredit = 0
            then gjae.accountingcurrencyamount
            else 0
        end as accounting_currency_debit_amount,
        case
            when gjae.iscredit = 1
            then gjae.accountingcurrencyamount
            else 0
        end as accounting_currency_credit_amount,
        coalesce(vt.accountnum, ct.accountnum) as customer_vendor_id,
        coalesce(vt.invoice, ct.invoice, ljt.invoice) as document_number,
        (ljt.exchrate / 100) as exchange_rate,
        --transaction currency amounts
        case
            when gjae.iscredit = 0
            then gjae.transactioncurrencyamount
            else 0
        end as transaction_currency_debit_amount,
        case
            when gjae.iscredit = 1
            then gjae.transactioncurrencyamount
            else 0
        end as transaction_currency_credit_amount
    from gjae
    left outer join gje
        on gjae.generaljournalentry = gje.recid
    left outer join asd
        on gjae.ledgerdimension = asd.recid
    left outer join vt
        on gje.subledgervoucher = vt.voucher and vt.row_num = 1
    left outer join ct
        on gje.subledgervoucher = ct.voucher and ct.row_num = 1
    left outer join ljt
        on gje.subledgervoucher = ljt.voucher and gjae.transactioncurrencycode = ljt.currencycode
    left outer join vm
        on vt.accountnum = vm.accountnum
    left outer join cm
        on ct.accountnum = cm.accountnum
    left outer join dpt
        on vm.party = dpt.recid or cm.party = dpt.recid
    left outer join fcp
        on gje.fiscalcalendarperiod = fcp.recid
)

select * from final
