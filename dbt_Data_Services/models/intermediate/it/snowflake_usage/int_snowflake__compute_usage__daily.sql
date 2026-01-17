with usage as (

    select

        usage_date,
        account_locator,
        service_type,
        credits_used_compute,
        credits_used_cloud_services,
        credits_adjustment_cloud_services,
        credits_used,
        credits_billed

    from {{ ref('stg_snowflake_organization_usage__metering_daily_history') }}

),

add_key as (

    select

        {{ dbt_utils.generate_surrogate_key(['usage_date', 'account_locator']) }} as usage_key,
        usage_date,
        account_locator,
        sum(credits_used_compute) as credits_used_compute,
        sum(credits_used_cloud_services) as credits_used_cloud_services,
        sum(credits_adjustment_cloud_services) as credits_adjustment_cloud_services,
        sum(credits_used) as credits_used,
        sum(credits_billed) as credits_billed

    from usage

    group by usage_key, usage_date, account_locator

)

select * from add_key
