-- union sales order fullfillment workbench tables for bioriginal NA(100), bioriginal eu (200), bioriginal asia (600)

with na_sofwb as (

    select

        order_number,
        line_number,
        sequence_number,
        item_number,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        '100' as company_code,
        total_amount_sales_currency,
        contract_number,
        canceled_order,
        round(price_sales_currency, 2) as price_sales_currency

    from {{ ref("stg_infor_ln__bioriginal_north_america_sales_order_fullfillment_workbench") }}

),

eu_sofwb as (

    select

        order_number,
        line_number,
        sequence_number,
        item_number,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        '200' as company_code,
        total_amount_sales_currency,
        contract_number,
        canceled_order,
        round(price_sales_currency, 2) as price_sales_currency

    from {{ ref("stg_infor_ln__bioriginal_europe_sales_order_fullfillment_workbench") }}

),

asia_sofwb as (

    select

        order_number,
        line_number,
        sequence_number,
        item_number,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        '600' as company_code,
        total_amount_sales_currency,
        contract_number,
        canceled_order,
        round(price_sales_currency, 2) as price_sales_currency

    from {{ ref("stg_infor_ln__bioriginal_asia_sales_order_fullfillment_workbench") }}

),

unioned as (

    select * from na_sofwb
    union all
    select * from eu_sofwb
    union all
    select * from asia_sofwb

),

add_key as (

    select

        order_number,
        line_number,
        sequence_number,
        item_number,
        quantity,
        sales_unit,
        customer_bp_id,
        invoice_date,
        fx_rate_to_home_curr,
        company_code,
        price_sales_currency,
        contract_number,
        canceled_order,
        round(total_amount_sales_currency, 2) as total_amount_sales_currency,
        item_number::string || '_' || company_code::string as item_key

    from unioned
)

select * from add_key
