with daily_rates as (

    select

        date,
        contract_number,
        usage_type,
        service_type,
        effective_rate,
        currency

    from {{ ref('stg_snowflake_organization_usage__rate_sheet_daily') }}

)

select * from daily_rates
