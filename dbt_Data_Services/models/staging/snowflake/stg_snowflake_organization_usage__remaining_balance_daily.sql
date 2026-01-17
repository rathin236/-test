with

source as (

    select *
    from {{ source('snowflake_organization_usage', 'remaining_balance_daily') }}

),

renamed as (

    select
        organization_name,
        contract_number,
        date,
        currency,
        free_usage_balance,
        capacity_balance,
        on_demand_consumption_balance,
        rollover_balance

    from source

)

select * from renamed
