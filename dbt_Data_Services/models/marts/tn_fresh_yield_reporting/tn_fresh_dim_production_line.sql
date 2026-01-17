with int_tn_fresh_yield_reporting__dim_production_line_ns as (
    select * from {{ ref('int_tn_fresh_yield_reporting__dim_production_line_ns') }}
),

int_tn_fresh_yield_reporting__dim_production_line_innova as (
    select * from {{ ref('int_tn_fresh_yield_reporting__dim_production_line_innova') }}
),

tn_fresh_dim_production_line as (
    select * from int_tn_fresh_yield_reporting__dim_production_line_ns

    union all

    select * from int_tn_fresh_yield_reporting__dim_production_line_innova
)

select * from tn_fresh_dim_production_line
