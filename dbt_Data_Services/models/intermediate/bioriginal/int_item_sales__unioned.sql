-- union item sales tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_is as (

    select

        item_number,
        item_product_category_description,
        '100' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_item_sales") }}

),

eu_is as (

    select

        item_number,
        item_product_category_description,
        '200' as company_code

    from {{ ref("stg_infor_ln__bioriginal_europe_item_sales") }}

),

asia_is as (

    select

        item_number,
        item_product_category_description,
        '600' as company_code

    from {{ ref("stg_infor_ln__bioriginal_asia_item_sales") }}

),

unioned as (

    select * from na_is
    union all
    select * from eu_is
    union all
    select * from asia_is

)

select * from unioned
