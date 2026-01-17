with

source as (

    select *
    from {{ source('snowflake_account_usage', 'metering_daily_history') }}

),

renamed as (

    select
        service_type,
        usage_date,
        credits_used_compute,
        credits_used_cloud_services,
        credits_used,
        credits_adjustment_cloud_services,
        credits_billed

    from source

)

select * from renamed
