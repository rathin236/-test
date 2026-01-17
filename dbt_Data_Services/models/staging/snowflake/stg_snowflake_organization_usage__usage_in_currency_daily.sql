with

source as (

    select *
    from {{ source('snowflake_organization_usage', 'usage_in_currency_daily') }}

),

renamed as (

    select
        organization_name,
        contract_number,
        account_name,
        account_locator,
        region,
        service_level,
        usage_date,
        usage_type,
        currency,
        usage,
        usage_in_currency

    from source

)

select * from renamed
