with compute as (

    select * from {{ ref('int_snowflake__compute_usage__daily') }}
),

storage as (

    select * from {{ ref('int_snowflake__storage_usage__daily') }}

),

key_date_account as (

    select
        usage_key,
        usage_date,
        account_locator
    from compute
    union all
    select
        usage_key,
        usage_date,
        account_locator
    from storage

),

uniques as (

    select distinct
        usage_key,
        usage_date,
        account_locator
    from key_date_account

),

add_storage_data as (

    select
        uniques.usage_key,
        uniques.usage_date,
        uniques.account_locator,
        storage.average_bytes as storage_average_bytes,
        storage.credits as storage_credits_used,
        storage.credits as storage_credits_billed
    from uniques

    left join storage on uniques.usage_key = storage.usage_key

),

add_compute_data as (

    select
        add_storage_data.usage_key,
        add_storage_data.usage_date,
        add_storage_data.account_locator,
        add_storage_data.storage_average_bytes,
        add_storage_data.storage_credits_used,
        compute.credits_used_compute as compute_credits_used,
        compute.credits_used_cloud_services,
        compute.credits_adjustment_cloud_services,
        compute.credits_used,
        add_storage_data.storage_credits_billed,
        compute.credits_billed as compute_credits_billed,
        (compute.credits_billed + add_storage_data.storage_credits_billed) as total_credits_used

    from add_storage_data

    left join compute on add_storage_data.usage_key = compute.usage_key

)

select * from add_compute_data
