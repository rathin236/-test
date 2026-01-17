with

source as (

    select * from {{ source('snowflake_organization_usage', 'metering_daily_history') }}

),

renamed as (

    select
        service_type,
        organization_name,
        account_name,
        usage_date,
        credits_used_compute,
        credits_used_cloud_services,
        credits_used,
        credits_adjustment_cloud_services,
        credits_billed,
        region,
        account_locator

    from source

)

select * from renamed
