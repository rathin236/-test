with

source as (

    select * from {{ source('snowflake_account_usage', 'metering_history') }}

),

renamed as (

    select
        service_type,
        start_time,
        end_time,
        entity_id,
        name,
        credits_used_compute,
        credits_used_cloud_services,
        credits_used,
        bytes,
        --rows (give compilations error and is not currently needed in dataset),
        files

    from source

)

select * from renamed
