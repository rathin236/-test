with work_orders as (
    select * from {{ ref('int_kcs__work_orders_kcs_aquacom') }}
)

select * from work_orders
