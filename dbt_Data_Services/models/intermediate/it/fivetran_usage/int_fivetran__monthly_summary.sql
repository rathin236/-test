{{
    config(
        materialized='incremental',
        unique_key=['measured_month','connector_name','destination_id', 'connector_id']
    )
}}

with connectors_joined as (
    select
        connector_id,
        connector_name,
        sync_frequency_category,
        --  company_name,
        destination_id,
        to_char(sync_start_time, 'yyyy-mm') as measured_month,
        max(sync_start_time) as last_sync_time,
        count(connector_id) as monthly_syncs,
        avg(sync_duration_seconds) as mean_sec,
        avg(sync_duration_minutes) as mean_min,
        variance(sync_duration_seconds) as variance_sec,
        variance(sync_duration_minutes) as variance_min,
        stddev(sync_duration_minutes) as std_dev_min,
        stddev(sync_duration_seconds) as std_dev_sec,
        min(sync_duration_minutes) as minimum_min,
        min(sync_duration_seconds) as min_sec,
        max(sync_duration_minutes) as max_min,
        max(sync_duration_seconds) as max_sec
    from {{ ref('int_fivetran__connectors_joined') }}
    group by all
),

active_rows as (
    select
        connector_name,
        destination_id,
        measured_month,
        total_incremental_rows,
        paid_rows
    from {{ ref('int_fivetran__usage_cost') }}
),

monthly_summary as (
    select
        connectors_joined.connector_id,
        active_rows.connector_name,
        active_rows.destination_id,
        connectors_joined.sync_frequency_category,
        --  connectors_joined.company_name,
        connectors_joined.last_sync_time,
        active_rows.measured_month,
        connectors_joined.mean_min,
        connectors_joined.mean_sec,
        connectors_joined.variance_sec,
        connectors_joined.variance_min,
        connectors_joined.std_dev_min,
        connectors_joined.std_dev_sec,
        connectors_joined.minimum_min,
        connectors_joined.min_sec,
        connectors_joined.max_min,
        connectors_joined.max_sec,
        active_rows.total_incremental_rows,
        active_rows.paid_rows
    --  active_rows.cost
    from connectors_joined
    inner join active_rows on
        connectors_joined.connector_name = active_rows.connector_name
        and connectors_joined.destination_id = active_rows.destination_id
        and connectors_joined.measured_month = active_rows.measured_month
)

select * from monthly_summary
