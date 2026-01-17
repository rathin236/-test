with

source as (

    select *
    from {{ source('snowflake_account_usage', 'warehouse_events_history') }}

),

renamed as (

    select
        timestamp,
        warehouse_id,
        warehouse_name,
        cluster_number,
        event_name,
        event_reason,
        event_state,
        user_name,
        role_name,
        query_id

    from source

)

select * from renamed
