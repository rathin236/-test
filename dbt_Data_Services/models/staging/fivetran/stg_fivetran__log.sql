with source as (

    select * from {{ source('fivetran', 'log') }}

),

renamed as (

    select
        id,
        time_stamp,
        connector_id,
        transformation_id,
        event,
        message_event,
        sync_id,
        _fivetran_synced as event_sync_time_stamp,
        message_data

    from source

)

select * from renamed
