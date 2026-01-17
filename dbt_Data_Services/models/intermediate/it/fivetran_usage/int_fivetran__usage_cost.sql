with usage_cost as (
    select
        destination_id,
        cost,
        measured_month
    from {{ ref('stg_fivetran__usage_cost') }}
),

mar as (
    select
        connector_id as connector_name,
        destination_id,
        to_char(measured_date, 'yyyy-mm') as measured_month,
        sum(incremental_rows) as total_incremental_rows
    from {{ ref('stg_fivetran__incremental_mar') }}
    group by connector_name, destination_id, measured_month
),

paid_mar as (
    select
        connector_id as connector_name,
        destination_id,
        to_char(measured_date, 'YYYY-MM') as measured_month,
        sum(incremental_rows) as paid_rows
    from {{ ref('stg_fivetran__incremental_mar') }}
    where free_type = 'PAID'
    group by connector_name, destination_id, measured_month
),

usage_rows_cost as (
    select
        mar.connector_name,
        mar.measured_month,
        mar.destination_id,
        mar.total_incremental_rows,
        paid_mar.paid_rows,
        usage_cost.cost
    from mar
    left join usage_cost
        on mar.destination_id = usage_cost.destination_id
            and mar.measured_month = usage_cost.measured_month
    left join paid_mar
        on mar.connector_name = paid_mar.connector_name
            and mar.destination_id = paid_mar.destination_id
            and mar.measured_month = paid_mar.measured_month
)

select * from usage_rows_cost
