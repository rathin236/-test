-- union items tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_itm as (

    select

        item_number,
        item_description,
        item_product_class,
        '100' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_items") }}

),

eu_itm as (

    select

        item_number,
        item_description,
        item_product_class,
        '200' as company_code

    from {{ ref("stg_infor_ln__bioriginal_europe_items") }}

),

asia_itm as (

    select

        item_number,
        item_description,
        item_product_class,
        '600' as company_code

    from {{ ref("stg_infor_ln__bioriginal_asia_items") }}

),

unioned as (

    select * from na_itm
    union all
    select * from eu_itm
    union all
    select * from asia_itm

)

select * from unioned
