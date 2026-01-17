-- union item costing tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_ic as (

    select

        standard_cost,
        item_number,
        '100' as company_code

    from {{ ref("stg_infor_ln__bioriginal_north_america_costing") }}

),

eu_ic as (

    select

        standard_cost,
        item_number,
        '200' as company_code

    from {{ ref("stg_infor_ln__bioriginal_asia_costing") }}

),

asia_ic as (

    select

        standard_cost,
        item_number,
        '600' as company_code

    from {{ ref("stg_infor_ln__bioriginal_asia_costing") }}

),

unioned as (

    select * from na_ic
    union all
    select * from eu_ic
    union all
    select * from asia_ic

)

select * from unioned
