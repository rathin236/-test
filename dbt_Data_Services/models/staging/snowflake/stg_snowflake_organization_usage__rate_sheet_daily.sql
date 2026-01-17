with

source as (

    select *
    from {{ source('snowflake_organization_usage', 'rate_sheet_daily') }}

),

renamed as (

    select
        date,
        organization_name,
        contract_number,
        account_name,
        account_locator,
        region,
        service_level,
        usage_type,
        currency,
        effective_rate,
        service_type

    from source

)

select * from renamed
