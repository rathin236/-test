with fact_cost_adjusted as (
    select * from {{ ref('int_global_sales__fact_cost_adjusted_d365') }}
)

select * from fact_cost_adjusted
