with usage as (
    select * from {{ ref('fct_snowflake__usage__daily') }}
),

rates as (
    select * from {{ ref('dim_snowflake__rates') }}
),


combined_rates_usage as (
    select
        usage.usage_key,
        usage.usage_date,
        usage.account_locator,
        usage.storage_average_bytes,
        usage.storage_credits_used,
        usage.compute_credits_used,
        usage.credits_used_cloud_services,
        usage.credits_adjustment_cloud_services,
        usage.credits_used,
        usage.storage_credits_billed,
        usage.compute_credits_billed,
        usage.total_credits_used,
        rates.rate_date,
        rates.contract_number,
        rates.compute_rate,
        rates.storage_rate,
        (rates.compute_rate * usage.compute_credits_billed) as compute_billed_cad,
        (rates.storage_rate * usage.storage_credits_billed) as storage_billed_cad,
        (compute_billed_cad + storage_billed_cad) as total_bill_cad

    from usage
    left join rates on
        usage.usage_date = rates.rate_date
)

select * from combined_rates_usage
