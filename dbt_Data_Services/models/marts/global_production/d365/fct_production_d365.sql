with fact_cost as (
    select * from {{ ref('int_global_production__d365_fact_production_batch_details') }}
)

select * from fact_cost
