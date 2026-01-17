with

source as (

    select *
    from {{ source('snowflake_account_usage', 'stage_storage_usage_history') }}

),

renamed as (

    select
        usage_date,
        average_stage_bytes

    from source

)

select * from renamed
