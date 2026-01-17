-- union sold to business partnert tables for bioriginal NA (100), bioriginal eu (200), bioriginal asia (600)

with na_stbp as (

    select

        sales_rep_id,
        customer_service_rep_id,
        customer_bp_id

    from {{ ref("stg_infor_ln__bioriginal_north_america_sold_to_business_partner") }}

),

eu_stbp as (

    select

        sales_rep_id,
        customer_service_rep_id,
        customer_bp_id

    from {{ ref("stg_infor_ln__bioriginal_europe_sold_to_business_partner") }}

),

asia_stbp as (

    select

        sales_rep_id,
        customer_service_rep_id,
        customer_bp_id

    from {{ ref("stg_infor_ln__bioriginal_asia_sold_to_business_partner") }}

),

unioned as (

    select * from na_stbp
    union all
    select * from eu_stbp
    union all
    select * from asia_stbp

)

select * from unioned
