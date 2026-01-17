with

source as (

    select *
    from {{ source('snowflake_reader_account_usage', 'storage_usage') }}

),

renamed as (

    select
        reader_account_name,
        usage_date,
        storage_bytes,
        stage_bytes,
        failsafe_bytes,
        reader_account_deleted_on

    from source

)

select * from renamed
