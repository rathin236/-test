-- union employees tables for bioriginal na (100), bioriginal eu (200), bioriginal asia (600)

with na_emp as (

    select

        sales_rep_id,
        sales_rep_name

    from {{ ref("stg_infor_ln__bioriginal_north_america_employees") }}

),

eu_emp as (

    select

        sales_rep_id,
        sales_rep_name

    from {{ ref("stg_infor_ln__bioriginal_europe_employees") }}

),

asia_emp as (

    select

        sales_rep_id,
        sales_rep_name

    from {{ ref("stg_infor_ln__bioriginal_asia_employees") }}

),

unioned as (

    select * from na_emp
    union all
    select * from eu_emp
    union all
    select * from asia_emp

)

select * from unioned
