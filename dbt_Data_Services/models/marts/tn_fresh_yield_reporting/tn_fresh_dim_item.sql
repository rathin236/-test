with int_tn_fresh_yield_reporting__dim_item_ns as (
    select * from {{ ref('int_tn_fresh_yield_reporting__dim_item_ns') }}
),

int_tn_fresh_yield_reporting__dim_item_innova as (
    select * from {{ ref('int_tn_fresh_yield_reporting__dim_item_innova') }}
),

tn_fresh_dim_item as (
    select * from int_tn_fresh_yield_reporting__dim_item_ns

    union all

    select * from int_tn_fresh_yield_reporting__dim_item_innova
)

select * from tn_fresh_dim_item
