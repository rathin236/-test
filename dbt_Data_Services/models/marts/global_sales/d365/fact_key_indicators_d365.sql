with cust_trans_invoice as (
    select * from {{ ref('int_global_sales__key_indicators_cust_invoice_trans_groupby') }}
),

cust_trans as (
    select * from {{ ref('stg_d365__cust_trans') }}
),

exchange_rate_currency_pair as (
    select * from {{ ref('stg_d365__exchange_rate_currency_pair') }}
),

exchange_rate as (
    select * from {{ ref('stg_d365__exchange_rate') }}
),

fact_key_indicators_d365 as (

    select
        cust_trans_invoice.invoiceid as invoice_id,
        cust_trans_invoice.salesid as sales_id,
        cust_trans_invoice.itemid as item_id,
        cust_trans.voucher as voucher_id,
        cust_trans_invoice."Release Status" as release_status,
        cust_trans_invoice."Order Status ID" as order_status_id,
        cust_trans_invoice."Sales Status ID" as sales_status_id,
        cust_trans_invoice."Sales Type ID" as sales_type_id,
        cust_trans_invoice."Inventory Location ID" as inventory_location_id,
        cust_trans_invoice."Inventory Site ID" as inventory_site_id,
        cust_trans_invoice."Delivery Address ID" as delivery_address_id,
        cust_trans.accountnum as account_number,
        cust_trans.orderaccount as order_account,
        cust_trans_invoice.financial_division_id,
        cust_trans_invoice.defaultdimension as default_dimension,
        cust_trans.documentnum as document_number,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans_invoice.currencycode', 'cust_trans_invoice.lineamount_total') }} as total_amount,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans_invoice.currencycode', 'cust_trans_invoice.lineamount_tax') }} as amount_tax,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans_invoice.currencycode', 'cust_trans_invoice.rebate_total') }} as total_rebate,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans_invoice.currencycode', 'cust_trans.settleamountreporting ') }}
            as total_settle_amount,
        {{ convert_to_usd('convert_exr.exchangerate', 'cust_trans_invoice.currencycode', 'cust_trans.settleamountreporting ') }}
        / count(*) over (partition by cust_trans_invoice.invoiceid) as line_total_settle_amount,
        cust_trans_invoice.invoice_volume_lbs as volume_lbs,
        cust_trans_invoice.qty,
        cust_trans_invoice.uom,
        'USD' as currency,
        cust_trans.txt,
        cust_trans.paymtermid as payment_terms,
        cust_trans.paymreference as payment_preference,
        cust_trans.paymmethod as payment_method,
        cust_trans.paymmode as payment_mode,
        cust_trans.companybankaccountid as company_bank_account_id,
        cust_trans.transtype as trans_type,
        cust_trans.documentdate as document_date,
        cust_trans.duedate as due_date,
        cust_trans.transdate as trans_date,
        cust_trans_invoice.rebate_date,
        -- cust_trans.modifieddatetime as modified_date_time,
        cust_trans.modifiedby as modified_by,
        cust_trans.createdby as created_by,
       cust_trans_invoice.createddatetime as create_date_time,
        -- cust_trans.last_processed_change_date_time,
        -- cust_trans.data_lake_modified_date_time,
        round(display_exr.exchangerate / 100, 6) as "exchange rate (cad-usd)",
        display_exr.validfrom as "valid from (cad-usd)",
        display_exr.validto as "valid to (cad-usd)"

    from cust_trans

    left join cust_trans_invoice
        on cust_trans.invoice = cust_trans_invoice.invoiceid
            and cust_trans.mcrpaymorderid = cust_trans_invoice.salesid

    left join exchange_rate_currency_pair as convert_ercp
        on cust_trans_invoice.currencycode = convert_ercp.fromcurrencycode
            and convert_ercp.tocurrencycode = 'USD'

    left join exchange_rate as convert_exr
        on convert_ercp.recid = convert_exr.exchangeratecurrencypair
            and (to_varchar(cust_trans.createddatetime, 'YYYY-MM-DD') between convert_exr.validfrom and convert_exr.validto)

    left join exchange_rate_currency_pair as display_exrcp
        on display_exrcp.tocurrencycode = 'USD'

    left join exchange_rate as display_exr
        on display_exrcp.recid = display_exr.exchangeratecurrencypair
            and to_varchar(cust_trans.createddatetime, 'yyyy-mm-dd') between display_exr.validfrom and display_exr.validto

)

select * from fact_key_indicators_d365

/* For Testing */
-- where invoice_id = 'INV00016515'
-- where sales_id = 'SO0022558' and item_id = 'P1000002'
