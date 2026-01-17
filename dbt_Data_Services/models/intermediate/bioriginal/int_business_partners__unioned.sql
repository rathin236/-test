-- join business partners tables for bioriginal NA live (100), bioriginal eu (200), bioriginal asia (600)

with na_bp as (

    select

        customer_bp_id,
        customer_name

    from {{ ref("stg_infor_ln__bioriginal_north_america_business_partners") }}

),

eu_bp as (

    select

        customer_bp_id,
        customer_name

    from {{ ref("stg_infor_ln__bioriginal_europe_business_partners") }}

),

asia_bp as (

    select

        customer_bp_id,
        customer_name

    from {{ ref("stg_infor_ln__bioriginal_asia_business_partners") }}

),

unioned as (

    select * from na_bp
    union all
    select * from eu_bp
    union all
    select * from asia_bp

)

select * from unioned
