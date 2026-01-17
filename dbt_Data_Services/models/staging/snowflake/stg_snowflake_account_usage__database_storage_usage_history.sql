with

source as (

    select *
    from
        {{ source('snowflake_account_usage', 'database_storage_usage_history') }}

),

renamed as (

    select
        usage_date,
        database_id,
        database_name,
        deleted,
        average_database_bytes,
        average_failsafe_bytes

    from source

)

select * from renamed
