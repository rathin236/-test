------ CALLING ALLTHE REFERENCE TABLES -----------

-- 1) selecting info from connectors joined (that pprovides all the connector info)

with connectors_joined as (
    select
        connector_id,
        connector_name,
        status,
        sync_frequency_category,
        official_connector_type as connector_type,
        created_date,
        sync_start_time,
        sync_end_time,
        destination_id,
        sync_duration_seconds,
        sync_duration_minutes,
        company_name,
        destination_name,
        application_name
    from {{ ref('int_fivetran__connectors_joined') }}
),

incremental_rows as (
    select
        connector_id,
        destination_id,
        last_incremental_row,
        total_incremental_rows,
        last_14_days,
        last_30_days
    from {{ ref('int_fivetran__incremental_rows') }}
),

--- creating latest sync information -------

-- Selecting the latest time sync ----

latest_timestamps as (
    select
        connector_id as conn_id,
        connector_name,
        sync_frequency_category,
        destination_id,
        max(sync_start_time) as latest_timestamp
    from {{ ref('int_fivetran__connectors_joined') }}
    group by connector_id, connector_name, sync_frequency_category, destination_id
),

-- filtering connector info for identifying its latest time stamp
connector_data as (
    select
        connectors_joined.connector_id,
        connectors_joined.connector_name,
        connectors_joined.status,
        connectors_joined.sync_frequency_category,
        connectors_joined.connector_type,
        connectors_joined.created_date,
        connectors_joined.sync_start_time,
        connectors_joined.sync_end_time,
        connectors_joined.sync_duration_seconds,
        connectors_joined.sync_duration_minutes,
        connectors_joined.destination_id,
        connectors_joined.company_name,
        connectors_joined.application_name,
        connectors_joined.destination_name,
        latest_timestamps.conn_id,
        latest_timestamps.latest_timestamp
    from connectors_joined
    inner join latest_timestamps
        on
            connectors_joined.connector_id = latest_timestamps.conn_id
            and connectors_joined.sync_start_time
            = latest_timestamps.latest_timestamp
            and connectors_joined.connector_name
            = latest_timestamps.connector_name
            and connectors_joined.sync_frequency_category
            = latest_timestamps.sync_frequency_category
),

-- filtering average 14 day sync duration for each connector
sync_summary as (
    select
        connectors_joined.connector_id,
        max(distinct connectors_joined.sync_end_time) as latest_sync_time,
        avg(connectors_joined.sync_duration_seconds) as avg_sync_sec_14_days,
        avg(connectors_joined.sync_duration_minutes) as avg_sync_min_14_days,
        stddev(connectors_joined.sync_duration_minutes) as stdev_14,
        stddev(connectors_joined.sync_duration_seconds) as stdev_14s
    from connectors_joined
    inner join latest_timestamps
        on connectors_joined.connector_id = latest_timestamps.conn_id
    where connectors_joined.sync_start_time >= dateadd(day, -14, latest_timestamps.latest_timestamp)
    group by connectors_joined.connector_id
),

-- filtering average 30 day sync duration for each connector on their last sync date
avg_sync_last_30_days as (
    select
        connectors_joined.connector_id,
        avg(connectors_joined.sync_duration_seconds) as avg_sync_sec_30_days,
        avg(connectors_joined.sync_duration_minutes) as avg_sync_min_30_days
    from connectors_joined
    inner join latest_timestamps
        on connectors_joined.connector_id = latest_timestamps.conn_id
    where connectors_joined.sync_start_time >= dateadd(day, -30, latest_timestamps.latest_timestamp)
    group by connectors_joined.connector_id
),

-- Merging everything together for displaying company info, 
-- latest logs, and all the connector info
latest_syncs as (
    select distinct
        connector_data.connector_id,
        connector_data.connector_name,
        connector_data.status,
        connector_data.sync_frequency_category,
        connector_data.connector_type,
        connector_data.created_date,
        connector_data.destination_id,
        connector_data.sync_duration_minutes,
        connector_data.sync_duration_seconds,
        connector_data.sync_start_time,
        connector_data.sync_end_time,
        connector_data.company_name,
        connector_data.application_name,
        connector_data.destination_name,
        incremental_rows.total_incremental_rows,
        incremental_rows.last_incremental_row,
        incremental_rows.last_14_days,
        incremental_rows.last_30_days,
        sync_summary.avg_sync_min_14_days,
        sync_summary.avg_sync_sec_14_days,
        sync_summary.stdev_14,
        sync_summary.stdev_14s,
        avg_sync_last_30_days.avg_sync_min_30_days,
        avg_sync_last_30_days.avg_sync_sec_30_days
    from connector_data
    inner join incremental_rows
        on connector_data.connector_name = incremental_rows.connector_id
            and connector_data.destination_id = incremental_rows.destination_id
    left join sync_summary
        on connector_data.connector_id = sync_summary.connector_id
    left join avg_sync_last_30_days
        on connector_data.connector_id = avg_sync_last_30_days.connector_id
)

select * from latest_syncs
