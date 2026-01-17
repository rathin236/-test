with journal_entry as (
    select
        {{ trim_columns_int('stg_d365__general_journal_entry') }}
    from {{ ref('stg_d365__general_journal_entry') }}
),

gen_account_entry as (
    select {{ trim_columns_int('stg_d365__general_journal_account_entry') }}
    from {{ ref('stg_d365__general_journal_account_entry') }}
),

company as (
    select {{ trim_columns_int('stg_d365__data_area') }}
    from {{ ref('stg_d365__data_area') }}
        where fno_id = 'TNSF'
),

funlcurr as (
    select accountingcurrency from {{ ref('stg_d365__ledger') }}
        where name = (select fno_id from company)
        and accountingcurrency is not null
),

enum as (
    select 
        {{ trim_columns_int('stg_d365__fds_enum_table') }}
    from {{ ref('stg_d365__fds_enum_table') }} 
    where enumid = 5576
),

default_dimension_view as (
    select {{ trim_columns_int('int_d365__default_dimension_view') }}
    from {{ ref('int_d365__default_dimension_view') }}
        where backingentitytype = '3665'
          and name = 'Division'
),

gjae as (
    select
        gjae.generaljournalentry,
        gjae.mainaccount,
        gjae.ledgeraccount,
        enum.enumvalue as postingtype, --originally enum.enumvaluelabel
        gjae.text,
        gjae.transactioncurrencycode,
        gjae.transactioncurrencyamount,
        gjae.accountingcurrencyamount,
        gjae.reportingcurrencyamount
    from gen_account_entry gjae
        left join enum
            on gjae.postingtype = enum.enumvalue
),

main_account as (
    select
        {{ trim_columns_int('int_d365__dim_main_accounts') }}
    from {{ ref('int_d365__dim_main_accounts') }}
),

vend_invoice as (
    select
        {{ trim_columns_int('stg_d365__vend_invoice_jour') }}
    from {{ ref('stg_d365__vend_invoice_jour') }}
),

FXRates_CAD as (
    select * from {{ ref('dim_exchange_rates') }}
    where from_ccy = 'CAD' and to_ccy = 'USD'
),

final as (
        select
            (select fno_id from company where trim(fno_id) = 'TNSF') as company_id,
            coalesce(vend_invoice.invoiceaccount, vend_invoice.orderaccount) as vendor_id,
            gjae.postingtype as document_type_id, --need to check on later, this needs to be posting type
            main_account.main_account_id as gl_account_id,
            (select * from funlcurr) as company_currency,
            journal_entry.subledgervoucher as voucher,
            coalesce(vend_invoice.invoiceid, journal_entry.documentnumber) as document_number,
            cast(coalesce(vend_invoice.documentdate, vend_invoice.invoicedate) as date) as document_date,
            cast(journal_entry.accountingdate as date) as gl_posting_date,
            cast(vend_invoice.duedate as date) as due_date,
            cast(journal_entry.createddatetime as date) as gl_posted_date,
            vend_invoice.purchid as po_number,
            gjae.transactioncurrencycode as trans_currency,
            coalesce(gjae.transactioncurrencyamount, 0) as originating_amount,
            {{ cad_current_rate('gjae.transactioncurrencycode','originating_amount','FXRates_CAD.rate' ) }} as cad_amount,
            {{ usd_current_rate('gjae.transactioncurrencycode','originating_amount','FXRates_CAD.rate' ) }} as usd_amount,
            /* Surrogate keys  */
            md5(concat(company_id, vendor_id, 'D365')) as sk_vendor_global,
            md5(concat(coalesce(gjae.postingtype, 'UNKNOWN'), 'D365')) as sk_doctype_global,
            md5(concat(company_id, trim(gl_account_id))) as sk_gl_account_global

        from journal_entry

        left join gjae
          on journal_entry.recid = gjae.generaljournalentry
        left join main_account
          on main_account.recid = gjae.mainaccount

        left join vend_invoice
          on vend_invoice.ledgervoucher = journal_entry.subledgervoucher

        left join default_dimension_view
          on default_dimension_view.default_dimension = vend_invoice.defaultdimension

        left join FXRates_CAD 
            on cast(journal_entry.createddatetime as date) = FXRates_CAD.fx_date

        where trim(upper(journal_entry.subledgervoucherdataareaid)) = 'TNSF'
        --   and to_date(journal_entry.accountingdate) >= '2024-01-01'
    )

select * from final
-- where document_number = '89834430'

/** FOR CONFIRMATION:
with gjae as (
    select *
    from {{ ref('stg_d365__general_journal_account_entry') }}
),

journal_entry as (
    select *
    from {{ ref('stg_d365__general_journal_entry') }}
),

ljt as (
    select *
    from {{ ref('stg_d365__ledger_journal_trans') }} --where voucher = 'API00066026'
),

vt as (
    select * from {{ref('stg_d365__vend_trans')}}
),

vm as (
    select *
        --accountnum,
        --party
    from {{ ref('stg_d365__vend_table') }}
),

dpt as (
    select *
        --recid,
        --name
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

FXRates_CAD as (
    select * from {{ ref('dim_exchange_rates') }}
    where from_ccy = 'CAD' and to_ccy = 'USD'
),

vend_invoice as (
    select
        *
    from {{ ref('stg_d365__vend_invoice_jour') }}
),


final as (
    select
        upper(coalesce(ljt.dataareaid,journal_entry.subledgervoucherdataareaid)) as company_id,
        vt.accountnum as vendor_id, --Ojo aqui
        gjae.postingtype as document_type_id,
        asd.mainaccountvalue as gl_account_id,
        vm.currency as company_currency, --need to confirm which exact column
        journal_entry.subledgervoucher as voucher,
        vt.invoice as document_number,
        cast(journal_entry.documentdate as date) as document_date,
        cast(journal_entry.accountingdate as date) as gl_posting_date, --need to confirm which exact column
        cast(vt.duedate as date) as due_date, --need to confirm which exact column
        cast(journal_entry.acknowledgementdate as date) as gl_posted_date, --need to confirm which exact column        
        '' as po_number, --need to confirm which exact column
        gjae.transactioncurrencycode as trans_currency,
        case 
            when gjae.iscredit = 0 then gjae.accountingcurrencyamount
            when gjae.iscredit = 1 then -gjae.accountingcurrencyamount
            else 0
        end as originating_amount,
        {{ cad_current_rate('gjae.transactioncurrencycode','originating_amount','FXRates_CAD.rate' ) }} as cad_amount,
        {{ usd_current_rate('gjae.transactioncurrencycode','originating_amount','FXRates_CAD.rate' ) }} as usd_amount,

        '' as Status,
        fcp.name as Period_Number,
        journal_entry.journalnumber as Journal_Entry_Number,
        --account segment numbers
        gjae.ledgeraccount as Account_Number,
        asd.mainaccountvalue as Main_Number,
        asd.costcentervalue as Cost_Centre,
        asd.departmentvalue as Department,
        asd.divisionvalue as Division,
        asd.locationvalue as Location,
        asd.productlinevalue as Product_Line,
        asd.cashflowtypevalue as Cash_Flow,
        asd.companyrelationshipvalue as Company_Relationship,
        --account segment descriptions
        '' as Account_Description,
        asd.mainaccountdescription as Main_Account_Description,
        asd.costcenterdescription as Cost_Centre_Description,
        asd.departmentdescription as Department_Description,
        asd.divisiondescription as Division_Description,
        asd.locationdescription as Location_Description,
        asd.productlinedescription as Product_Line_Description,
        asd.cashflowdescription as Cash_Flow_Description,
        asd.companyrelationshipdescription as Company_Relationship_Description,
        --accounting currency debits and credits
        case 
            when gjae.iscredit = 0
            then gjae.accountingcurrencyamount 
            else 0
        end as Accounting_Currency_Debit_Amount,
        case 
            when gjae.iscredit = 1
            then gjae.accountingcurrencyamount 
            else 0
        end as Accounting_Currency_Credit_Amount,
        --subledger details
        dpt.name as Customer_Vendor_Name,
        '' as Canceled,
        (ljt.exchrate/100) as Exchange_Rate,
        gjae.text as Text_Description,
        --transaction currency amounts
        case 
            when gjae.iscredit = 0
            then gjae.transactioncurrencyamount
            else 0
        end as Transaction_Currency_Debit_Amount,
        case 
            when gjae.iscredit = 1
            then gjae.transactioncurrencyamount
            else 0
        end as Transaction_Currency_Credit_Amount 
    from gjae

    left outer join journal_entry
        on gjae.generaljournalentry = journal_entry.recid
    left outer join asd
        on gjae.ledgerdimension = asd.recid
    left outer join vt
        on journal_entry.subledgervoucher = vt.voucher 
        and asd.mainaccountvalue = vt.summaryaccountid 
        and gjae.accountingcurrencyamount = vt.amountmst
        --and davc.mainaccountvalue != '211210'
        --and vt.row_num = 1

    left outer join ljt
        on journal_entry.subledgervoucher = ljt.voucher and gjae.transactioncurrencycode = ljt.currencycode
    left outer join vm
        on vt.accountnum = vm.accountnum
    left outer join dpt
        on vm.party = dpt.recid
    left outer join fcp
        on journal_entry.fiscalcalendarperiod = fcp.recid

    --where davc.mainaccountvalue != '211210'

    left join FXRates_CAD 
        on cast(journal_entry.accountingdate as date) = FXRates_CAD.fx_date
    left join vend_invoice
        on vend_invoice.ledgervoucher = journal_entry.subledgervoucher
)

select * from final
where voucher = 'API00066026'
**/