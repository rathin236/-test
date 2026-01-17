-- join sort data budget totals tables for bioriginal NA live (100), bioriginal eu (200), bioriginal asia (600)

with na_sort_data as (
    select
        t_atvs,
        "Sort",
        "Year",
        "Company"
    from {{ ref("stg_infor_ln__bioriginal_north_america_sort_data_budget_totals") }}
),

eu_sort_data as (
    select
        t_atvs,
        "Sort",
        "Year",
        "Company"
    from {{ ref("stg_infor_ln__bioriginal_europe_sort_data_budget_totals") }}
),

asia_sort_data as (
    select
        t_atvs,
        "Sort",
        "Year",
        "Company"
    from {{ ref("stg_infor_ln__bioriginal_asia_sort_data_budget_totals") }}
),

unioned as (
    select * from na_sort_data
    union all
    select * from eu_sort_data
    union all
    select * from asia_sort_data
)

select * from unioned
