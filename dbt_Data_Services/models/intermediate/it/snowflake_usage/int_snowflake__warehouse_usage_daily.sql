with wharehouse_usage as (

    select * from {{ ref('stg_snowflake_organization_usage__warehouse_metering_history') }}
),

aggregates as (

    select
        account_locator,
        warehouse_name,
        date(end_time) as usage_date,
        sum(credits_used) as total_credits_used,
        sum(credits_used_compute) as total_credits_used_computed,
        sum(credits_used_cloud_services) as total_credits_used_cloud_services

    from wharehouse_usage

    group by usage_date, account_locator, warehouse_name
)

select * from aggregates
