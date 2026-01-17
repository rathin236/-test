with main_warehouses as (

    select
        warehouse_id,
        warehouse_name,
        sum(case when event_name = 'DROP_WAREHOUSE' then 1 else 0 end) as dropped,
        'YJ63875' as account_locator
    from {{ ref('stg_snowflake_account_usage__warehouse_events_history') }}
    group by warehouse_id, warehouse_name

),

reader_warehouses as (

    select distinct
        warehouse_id,
        warehouse_name,
        0 as dropped,
        reader_account_name as account_locator
    from {{ ref('stg_snowflake_reader_account_usage__warehouse_metering_history') }}

),

all_warehouses as (

    select * from main_warehouses
    union all
    select * from reader_warehouses

)

select * from all_warehouses
