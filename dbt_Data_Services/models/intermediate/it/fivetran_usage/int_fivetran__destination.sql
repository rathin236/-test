-- models/dim_destination.sql

with application_name as (
    select
        destination_name,
        application_name
    from {{ ref('fivetran_destination_application_mapping') }}
),

stg_destination as (
    select
        account_id,
        id,
        name,
        region
    from {{ ref('stg_fivetran__destination') }}
),

destination as (
    select
        stg_destination.account_id,
        stg_destination.id as destination_id,
        stg_destination.name as destination_name,
        stg_destination.region as destination_region,
        application_name.application_name  -- Use the application_name from the mapping
    from stg_destination
    left join application_name
        on stg_destination.name = application_name.destination_name
),

account as (
    select
        id as account_id,
        name as account_name,
        created_at as account_created_at,
        status as account_status,
        country as account_country
    from {{ ref('stg_fivetran__account') }}
),

dim_destination as (
    select
        destination.account_id,
        destination.destination_id,
        destination.destination_name,
        destination.destination_region,
        destination.application_name,
        account.account_name,
        account.account_created_at,
        account.account_status,
        account.account_country
    from destination
    inner join account
        on destination.account_id = account.account_id
)

select * from dim_destination
