-- join sort data tables for bioriginal NA live (100), bioriginal eu (200), bioriginal asia (600)

with na_sort_data as (
    select
        t_atvs,
        "Sort",
        "Period",
        "Year",
        "Inventory Unit",
        "Ordered Unit",
        "Price Unit",
        round("Amount", 2) as "Amount",
        round(cogs, 2) as cogs
    from {{ ref("stg_infor_ln__bioriginal_north_america_sort_data") }}
),

eu_sort_data as (
    select
        t_atvs,
        "Sort",
        "Period",
        "Year",
        "Inventory Unit",
        "Ordered Unit",
        "Price Unit",
        round("Amount", 2) as "Amount",
        round(cogs, 2) as cogs
    from {{ ref("stg_infor_ln__bioriginal_europe_sort_data") }}
),

asia_sort_data as (
    select
        t_atvs,
        "Sort",
        "Period",
        "Year",
        "Inventory Unit",
        "Ordered Unit",
        "Price Unit",
        round("Amount", 2) as "Amount",
        round(cogs, 2) as cogs
    from {{ ref("stg_infor_ln__bioriginal_asia_sort_data") }}
),

unioned as (
    select * from na_sort_data
    union all
    select * from eu_sort_data
    union all
    select * from asia_sort_data
)

select * from unioned
