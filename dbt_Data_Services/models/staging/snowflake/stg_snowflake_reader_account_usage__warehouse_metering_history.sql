with

source as (

    select *
    from
        {{ source('snowflake_reader_account_usage', 'warehouse_metering_history') }}

),

renamed as (

    select
        reader_account_name,
        start_time,
        end_time,
        warehouse_id,
        warehouse_name,
        credits_used,
        credits_used_compute,
        credits_used_cloud_services,
        reader_account_deleted_on

    from source

)

select * from renamed
