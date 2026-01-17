with
    gje as (
        select
        {{ trim_columns_int('stg_d365__general_journal_entry') }}
        from {{ ref('stg_d365__general_journal_entry') }}
    ),

    gen_account_entry as (
        select
        {{ trim_columns_int('stg_d365__general_journal_account_entry') }}
        from {{ ref('stg_d365__general_journal_account_entry') }}
    ),

    enum as (
        select 
        {{ trim_columns_int('stg_d365__fds_enum_table') }}
        from {{ ref('stg_d365__fds_enum_table') }} 
        where enumid = 5576
        --enumlabel = 'POSTING TYPE' and enumid = 5576
    ),

    default_dimension_view as (
    select * from {{ ref('int_d365__default_dimension_view') }}
    where backingentitytype = '3665'
        and name = 'Division'
    ),

    gjae as (
        select
            gjae.generaljournalentry,
            gjae.mainaccount,
            gjae.ledgeraccount,
            enum.enumvaluelabel as postingtype,
            gjae.text,
            gjae.transactioncurrencycode,
            gjae.transactioncurrencyamount,
            gjae.accountingcurrencyamount,
            gjae.reportingcurrencyamount
        from  gen_account_entry gjae
        left join enum on gjae.postingtype = enum.enumvalue
    ),

    ma as (
        select
        {{ trim_columns_int('int_d365__dim_main_accounts') }}
        from {{ ref('int_d365__dim_main_accounts') }}
    ),

    cust_invoice as (
        select
        {{ trim_columns_int('stg_d365__cust_invoice_jour') }}
        from {{ ref('stg_d365__cust_invoice_jour') }}
    ),

    final as (

        select
            gje.journalnumber as journal_number,
            gje.subledgervoucher as voucher,
            substring(gje.subledgervoucher, 1, 3) as voucher_type,
            to_date(gje.accountingdate) as accounting_date,
            gjae.ledgeraccount as ledger_account,
            ma.main_account_id,
            gjae.text as description,
            gjae.transactioncurrencycode as currency,
            gjae.transactioncurrencyamount * (-1) as amountintransactioncurrency,
            gjae.accountingcurrencyamount * (-1) as amount,
            gjae.reportingcurrencyamount * (-1) as amountinreportingcurrency,
            gjae.postingtype,
            case 
                when cust_invoice.orderaccount is null and substring(gje.subledgervoucher, 1, 3) = 'GLJ' then
                    case when gjae.ledgeraccount like ('%400100-1100%') then 'C1000121'
                        when gjae.ledgeraccount like ('%400100-1080%') then 'C1000120'
                        when gjae.ledgeraccount like ('%400100-1070%') then 'C1000126'
                        when gjae.ledgeraccount like ('%400100-1050%') then 'C1000049'
                        when gjae.ledgeraccount like ('%400020-1050-RP%') then 'C1000049'
                        else null
                    end
                else cust_invoice.orderaccount
            end as customer_account,
            cust_invoice.invoiceaccount as invoice_account,
            cust_invoice.salesid as sales_id,
            cust_invoice.invoiceid as invoice_id,
            cust_invoice.inventlocationid as warehouse_sk,
            cust_invoice.invoicepostaladdress,
            case 
                when cust_invoice.deliverypostaladdress is null and substring(gje.subledgervoucher, 1, 3) = 'GLJ' then
                    case when gjae.ledgeraccount like ('%400100-1100%') then '5637554826'
                        when gjae.ledgeraccount like ('%400100-1080%') then '5637155089'
                        when gjae.ledgeraccount like ('%400100-1070%') then '5637150829'
                        when gjae.ledgeraccount like ('%400100-1050%') then '5637447578'
                        when gjae.ledgeraccount like ('%400020-1050-RP%') then '5637447578'
                        else null
                    end
                when cust_invoice.orderaccount = 'C1000121' and deliverypostaladdress = '5637150821' then '5637554826'
                else deliverypostaladdress
            end as deliverypostaladdress,
           -- cust_invoice.d
            abu.value_ as financial_division_id,
            gje.documentnumber as documentnumber,
            gje.documentdate as documentdate,
            gje.createdby as createdby,
            gje.createddatetime as createddatetime,
            gje.modifiedby as modifiedby,
            gje.modifieddatetime as modifieddatetime,
            gje.subledgervoucherdataareaid as legal_entity,
            ma.sk_main_account

        from gje
        join gjae on gje.recid = gjae.generaljournalentry
        join ma on ma.recid = gjae.mainaccount

        left join cust_invoice 
            on cust_invoice.ledgervoucher = gje.subledgervoucher

        left join default_dimension_view
            on default_dimension_view.default_dimension = cust_invoice.defaultdimension

        left join {{ ref('int_d365__dim_attribute_om_business_unit') }} as abu
            on default_dimension_view.entityinstance = abu.key_
        where
            trim(upper(gje.subledgervoucherdataareaid)) = 'TNSF'
            and to_date(gje.AccountingDate) >= '2024-01-01'
    )

select 
    *, md5(concat(customer_account, deliverypostaladdress)) as sk_cust_id
from final
