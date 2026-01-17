with all_trans as (
    select 
        recid,
        accountnum,
        transdate,
        transtype,
        invoice,
        txt,
        voucher,
        currencycode,
        amountmst,
        exchadjustmentreporting,
        defaultdimension,
        dataareaid,
        paymtermid,
        closed as closing_date,
        case
            when year(closed) = 1900 then 'Open'
        else 'Closed'
        end as transaction_status
    from {{ ref('stg_d365__cust_trans') }}
    where not (transtype in (2, 8) and invoice is not null)
),

enum_value as (
    select 
        enumvalue,
        enumid,
        enumvaluename,
        enumvaluelabel
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 2715
),

default_dimension_view as (
    select * from {{ ref('int_d365__default_dimension_view') }}
    where backingentitytype = '3665'
        and name = 'Division'
),

cust_transactions as (
    select 
        atrs.recid,
        atrs.accountnum as account_number,
        atrs.transdate as transaction_date,
        enum_value.enumvaluelabel as transaction_type,
        atrs.invoice as invoice_id,
        null as sales_id,
        null as item_id,
        atrs.txt as transaction_description,
        atrs.voucher,
        atrs.amountmst as amount_usd,
        atrs.currencycode,
        null as quantity,
        null as salesunit,
        null as salesprice,
        null as invoice_volume_lbs,
        null as rebate_date,
        null as rebate_total,
        atrs.exchadjustmentreporting as exchange_adjustment,
        atrs.dataareaid,
        atrs.paymtermid as payment,
        null as purchaseorder,
        null as dlvmode,
        null as origsalesid,
        abu.value_ as financial_division_id,
        'trans' as source,
        atrs.closing_date,
        atrs.transaction_status

        from all_trans atrs
        left join enum_value on enum_value.enumvalue = atrs.transtype

        left join default_dimension_view
        on default_dimension_view.default_dimension = atrs.defaultdimension

        left join {{ ref('int_d365__dim_attribute_om_business_unit') }} as abu
        on default_dimension_view.entityinstance = abu.key_
),

inv_line_trans as (
    select * from {{ ref('int_global_sales__all_invoices') }}
),

cust_trans as (
    select * from cust_transactions
    union all
    select * from inv_line_trans
),

exchange_rate_currency_pair as (
    select * from {{ ref('stg_d365__exchange_rate_currency_pair') }}
),

exchange_rate as (
    select * from {{ ref('stg_d365__exchange_rate') }}
),

fact_key_indicators_d365 as (
    select
        cust_trans.recid,
        cust_trans.account_number,
        cust_trans.transaction_date,
        cust_trans.transaction_type,
        cust_trans.transaction_description,
        cust_trans.invoice_id,
        cust_trans.sales_id,
        cust_trans.item_id,
        cust_trans.voucher as voucher_id,
        cust_trans.financial_division_id,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans.currencycode', 'cust_trans.amount_usd') }} as total_amount,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans.currencycode', 'cust_trans.rebate_total') }} as total_rebate,
        cust_trans.rebate_date,
        cust_trans.invoice_volume_lbs as volume_lbs,
        cust_trans.quantity,
        cust_trans.salesunit,
        'USD' as currency,
        cust_trans.payment,
        cust_trans.purchaseorder,
        cust_trans.dlvmode,
        cust_trans.origsalesid,
        cust_trans.source,
        round(display_exr.exchangerate / 100, 6) as "exchange rate (cad-usd)",
        display_exr.validfrom as "valid from (cad-usd)",
        display_exr.validto as "valid to (cad-usd)",
        cust_trans.closing_date,
        cust_trans.transaction_status

    from cust_trans

    left join exchange_rate_currency_pair as convert_ercp
        on cust_trans.currencycode = convert_ercp.fromcurrencycode
            and convert_ercp.tocurrencycode = 'USD'

    left join exchange_rate as convert_exr
        on convert_ercp.recid = convert_exr.exchangeratecurrencypair
            and to_varchar(cust_trans.transaction_date, 'YYYY-MM-DD') between convert_exr.validfrom and convert_exr.validto

    left join exchange_rate_currency_pair as display_exrcp
        on display_exrcp.tocurrencycode = 'USD'

    left join exchange_rate as display_exr
        on display_exrcp.recid = display_exr.exchangeratecurrencypair
            and to_varchar(cust_trans.transaction_date, 'yyyy-mm-dd') between display_exr.validfrom and display_exr.validto
)

select * from fact_key_indicators_d365