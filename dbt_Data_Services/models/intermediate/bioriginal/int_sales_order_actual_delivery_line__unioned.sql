-- union sales order actual delivery line tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_soadl as (

    select

        round(sum(cogs_home_currency), 2) as total_cogs_home_currency,
        order_number,
        line_number,
        sequence_number,
        '100' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_sales_order_actual_delivery_line") }}

    group by all

),

eu_soadl as (

    select

        round(sum(cogs_home_currency), 2) as total_cogs_home_currency,
        order_number,
        line_number,
        sequence_number,
        '200' as company_code

    from {{ ref("stg_infor_ln__bioriginal_europe_sales_order_actual_delivery_line") }}

    group by all

),

asia_soadl as (

    select

        round(sum(cogs_home_currency), 2) as total_cogs_home_currency,
        order_number,
        line_number,
        sequence_number,
        '600' as company_code

    from {{ ref("stg_infor_ln__bioriginal_asia_sales_order_actual_delivery_line") }}

    group by all

),

unioned as (

    select * from na_soadl
    union all
    select * from eu_soadl
    union all
    select * from asia_soadl

)

select * from unioned
