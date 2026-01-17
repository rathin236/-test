-- Getting distinct values from the connector table
with distinct_connector as (
    select distinct
        connector_name,
        destination_id
    from
        {{ ref('stg_fivetran__connector') }}
),

-- Get unique combinations from the incremental_mar table
unique_incremental_mar as (
    select distinct
        connector_id,
        destination_id
    from
        {{ ref('stg_fivetran__incremental_mar') }}
),

-- Count mismatching values in connector table
mismatch_connector as (
    select
        distinct_connector.connector_name,
        distinct_connector.destination_id,
        'connector' as table_name,
        count(*) as mismatch_count
    from
        distinct_connector as distinct_connector
    left join
        unique_incremental_mar as unique_mar
        on
            distinct_connector.connector_name = unique_mar.connector_id
            and distinct_connector.destination_id = unique_mar.destination_id
    where
        unique_mar.connector_id is null
    group by
        distinct_connector.connector_name,
        distinct_connector.destination_id
),

-- Count mismatching values in incremental_mar table
mismatch_incremental_mar as (
    select
        unique_mar.connector_id,
        unique_mar.destination_id,
        'incremental_mar' as table_name,
        count(*) as mismatch_count
    from
        unique_incremental_mar as unique_mar
    left join
        distinct_connector as distinct_connector
        on
            unique_mar.connector_id = distinct_connector.connector_name
            and unique_mar.destination_id = distinct_connector.destination_id
    where
        distinct_connector.connector_name is null
    group by
        unique_mar.connector_id,
        unique_mar.destination_id
),

-- Combine mismatch counts from both tables
no_mar_connectors as (
    select * from mismatch_connector
    union all
    select * from mismatch_incremental_mar
)

select * from no_mar_connectors
