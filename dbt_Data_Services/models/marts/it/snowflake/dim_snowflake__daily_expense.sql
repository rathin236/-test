with expenses as (

    select * from {{ ref('int_snowflake__daily_expenses') }}

),

conversion as (

    select * from {{ ref('dim_exchange_rates') }}
),

conversion_joined as (

    select

        expenses.account_locator,
        expenses.usage_type,
        expenses.currency,
        expenses.usage_date,
        expenses.daily_usage_credits,
        expenses.daily_usage_currency,
        conversion.rate as usd_to_cad_rate

    from expenses

    left join conversion on expenses.usage_date = conversion.fx_date

    where conversion.from_ccy = 'USD' and conversion.to_ccy = 'CAD'

),

converted as (

    select

        account_locator,
        usage_type,
        usage_date,
        daily_usage_credits,
        (daily_usage_currency * usd_to_cad_rate) as daily_usage_cad,
        daily_usage_currency as daily_usage_usd

    from conversion_joined
    where account_locator='YJ63875'

)

select * from converted
