with mar as (
    select
        connector_id,
        measured_date,
        incremental_rows,
        destination_id
    from {{ ref('stg_fivetran__incremental_mar') }}
),

max_measured_dates as (
    select
        connector_id as conn_id,
        destination_id,
        max(measured_date) as max_measured_date
    from {{ ref('stg_fivetran__incremental_mar') }}
    group by conn_id, destination_id
),

incremental_rows as (
    select
        connector_id as conn_id,
        destination_id,
        count(*) as incremental_rows
    from mar
    group by connector_id, destination_id
),

last_incremental_row as (
    select
        max_measured_dates.conn_id,
        count(*) as last_incremental_rows
    from mar
    inner join max_measured_dates as max_measured_dates
        on mar.connector_id = max_measured_dates.conn_id
            and mar.measured_date = max_measured_dates.max_measured_date
    group by max_measured_dates.conn_id
),

last_14_days_data as (
    select
        mar.connector_id as conn_id,
        count(*) as last_14_days
    from mar
    inner join max_measured_dates
        on mar.connector_id = max_measured_dates.conn_id
    where mar.measured_date >= dateadd(day, -14, max_measured_dates.max_measured_date)
    group by mar.connector_id
),

last_30_days_data as (
    select
        mar.connector_id as conn_id,
        count(*) as last_30_days
    from mar
    inner join max_measured_dates as max_measured_dates
        on mar.connector_id = max_measured_dates.conn_id
    where mar.measured_date >= dateadd(day, -30, max_measured_dates.max_measured_date)
    group by mar.connector_id
),

last_90_days_data as (
    select
        mar.connector_id as conn_id,
        count(*) as last_90_days
    from mar
    inner join max_measured_dates as max_measured_dates
        on mar.connector_id = max_measured_dates.conn_id
    where mar.measured_date >= dateadd(day, -90, max_measured_dates.max_measured_date)
    group by mar.connector_id
),

mar_summary as (
    select
        lir.conn_id as connector_id,
        incremental_rows.destination_id,
        incremental_rows.incremental_rows as total_incremental_rows,
        lir.last_incremental_rows as last_incremental_row,
        l14d.last_14_days,
        l30d.last_30_days,
        l90d.last_90_days
    from incremental_rows
    left join last_incremental_row as lir on incremental_rows.conn_id = lir.conn_id
    left join last_14_days_data as l14d on incremental_rows.conn_id = l14d.conn_id
    left join last_30_days_data as l30d on incremental_rows.conn_id = l30d.conn_id
    left join last_90_days_data as l90d on incremental_rows.conn_id = l90d.conn_id
)

select * from mar_summary
