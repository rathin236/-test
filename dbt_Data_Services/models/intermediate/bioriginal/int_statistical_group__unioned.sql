-- union statistical group tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_sg as (

    select

        product_category_description,
        id,
        '100' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_statistical_group") }}

),

eu_sg as (

    select

        product_category_description,
        id,
        '200' as company_code

    from {{ ref("stg_infor_ln__bioriginal_europe_statistical_group") }}

),

asia_sg as (

    select

        product_category_description,
        id,
        '600' as company_code

    from {{ ref("stg_infor_ln__bioriginal_asia_statistical_group") }}

),

unioned as (

    select * from na_sg
    union all
    select * from eu_sg
    union all
    select * from asia_sg

)

select * from unioned
