-- union product tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_pc as (

    select

        product_category_grouping_description,
        item_product_class,
        '100' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_product_classes") }}

),

eu_pc as (

    select

        product_category_grouping_description,
        item_product_class,
        '200' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_product_classes") }}

),

asia_pc as (

    select

        product_category_grouping_description,
        item_product_class,
        '600' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_product_classes") }}

),

unioned as (

    select * from na_pc
    union all
    select * from eu_pc
    union all
    select * from asia_pc

)

select * from unioned
