with warehouses_daily as (

    select * from {{ ref("int_snowflake__warehouse_usage_per_day") }}
)

select * from warehouses_daily
