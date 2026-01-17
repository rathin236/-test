-- Reference tables
with connector as (
    select
        connector_id,
        connector_name,
        connector_created_date as created_date,
        cast(sync_frequency as varchar) as sync_frequency_category,

        -- foreign keys
        connector_type_id,
        destination_id,
        case
            when paused = true
                then 'Paused'
            when paused = false
                then 'Active'
            else 'Unknown'
        end as status

    from {{ ref("stg_fivetran__connector") }}
),

connector_type as (
    select
        id as connector_type_id,
        official_connector_name as official_connector_type
    from {{ ref("stg_fivetran__connector_type") }}
),

log as (
    select
        connector_id,
        sync_id,
        min(time_stamp) as sync_start_time,
        max(time_stamp) as sync_end_time,
        datediff(second, min(time_stamp), max(time_stamp)) as sync_duration_seconds,
        datediff(minute, min(time_stamp), max(time_stamp)) as sync_duration_minutes
    from {{ ref("stg_fivetran__log") }}
    where message_event in ('sync_start', 'sync_end')
    group by connector_id, sync_id
),

-- collecting monthly mar insights on each connector per destination
-- this determines costs

company_connector as (
    select
        id,
        company_id,
        connector_id,
        destination_id,
        application_id
    from {{ ref('stg_fivetran__company_connector') }}
),

destination as (
    select
        destination_id,
        destination_name,
        destination_region,
        -- application_name,
        account_name,
        account_created_at,
        account_status,
        account_country

    from {{ ref('int_fivetran__destination') }}
),

company_name as (
    select
        company_id,
        company_name,
        region as company_region,
        country as company_country
    from
        {{ ref('stg_fivetran__company_name') }}
),

application as (
    select
        application_id,
        application_name,
        application_tier,
        application_environment
    from
        {{ ref('stg_fivetran__application_name') }}
),

company_application as (
    select
        company_connector.company_id,
        company_connector.connector_id,
        company_connector.destination_id,
        company_name.company_name,
        destination.destination_name,
        --destination.application_name,
        connector.connector_name,
        application.application_name,
        application.application_tier,
        application.application_environment
    from company_connector
    left join
        company_name on company_connector.company_id = company_name.company_id
    left join
        destination on company_connector.destination_id = destination.destination_id
    left join
        connector on company_connector.connector_id = connector.connector_id
    left join
        application on company_connector.application_id = application.application_id
)
--select * from company_application
,

connectors_joined as (
    select
        connector.connector_id,
        connector.connector_name,
        connector.created_date,
        connector.status,
        connector.sync_frequency_category,
        connector.destination_id,
        connector_type.official_connector_type,
        log.sync_start_time,
        log.sync_end_time,
        log.sync_duration_seconds,
        log.sync_duration_minutes,
        company_application.company_name,
        company_application.destination_name,
        company_application.application_name,
        company_application.application_tier,
        company_application.application_environment
    from connector
    left join connector_type on connector.connector_type_id = connector_type.connector_type_id
    left join log on connector.connector_id = log.connector_id
    left join company_application on connector.connector_id = company_application.connector_id
        and connector.destination_id = company_application.destination_id
)

-- Main query
select * from connectors_joined
