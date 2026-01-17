-- union sales order status tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_stat as (

    select

        sales_order_status,
        sales_currency,
        order_number,
        delivery_date

    from {{ ref("stg_infor_ln__bioriginal_north_america_sales_order_status") }}

),

eu_stat as (

    select

        sales_order_status,
        sales_currency,
        order_number,
        delivery_date

    from {{ ref("stg_infor_ln__bioriginal_europe_sales_order_status") }}

),

asia_stat as (

    select

        sales_order_status,
        sales_currency,
        order_number,
        delivery_date

    from {{ ref("stg_infor_ln__bioriginal_asia_sales_order_status") }}

),

unioned as (

    select * from na_stat
    union all
    select * from eu_stat
    union all
    select * from asia_stat

)

select * from unioned
