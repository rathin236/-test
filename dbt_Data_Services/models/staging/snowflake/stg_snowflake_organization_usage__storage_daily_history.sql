with

source as (

    select * from {{ source('snowflake_organization_usage', 'storage_daily_history') }}

),

renamed as (

    select
        service_type,
        organization_name,
        account_name,
        usage_date,
        average_bytes,
        region,
        account_locator,
        credits

    from source

)

select * from renamed
