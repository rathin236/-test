select
    account_locator,
    region,
    service_level,
    usage_type,
    currency,
    usage_date,
    (usage) as daily_usage_credits,
    (usage_in_currency) as daily_usage_currency
from {{ ref('stg_snowflake_organization_usage__usage_in_currency_daily') }}
group by all
