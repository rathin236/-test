with

source as (

    select * from {{ source('snowflake_account_usage', 'storage_usage') }}

),

renamed as (

    select
        usage_date,
        storage_bytes,
        stage_bytes,
        failsafe_bytes

    from source

)

select * from renamed
