/*******************************************************************************************************************************************
    Daily exchange rates for these currencies - USD, CAD, CLP, JPY, EUR, GBP

*******************************************************************************************************************************************/

with calendar as (
    select * from {{ ref('dim_date') }}
    where "Key_Date" > '2018-12-31'
        and "Key_Date" <= current_date()
),

currency_pairs as (
    select distinct
        from_ccy,
        to_ccy
    from {{ ref('int_ancillary__daily_exchange_rates_multi_currency') }}
),

all_dates_currencies as (
    select
        caldr."Key_Date" as key_date,
        cprs.from_ccy,
        cprs.to_ccy
    from
        calendar as caldr
    cross join
        currency_pairs as cprs
),

joined_data as (
    select
        adcs.key_date,
        adcs.from_ccy,
        adcs.to_ccy,
        rate.rate
    from
        all_dates_currencies as adcs
    left join
        {{ ref('int_ancillary__daily_exchange_rates_multi_currency') }} as rate
        on
            adcs.key_date = rate.ratedate and adcs.from_ccy = rate.from_ccy and adcs.to_ccy = rate.to_ccy
),

backfilled_data as (
    select
        key_date,
        from_ccy,
        to_ccy,
        rate,
        last_value(
            rate ignore nulls) over
        (
            partition by from_ccy, to_ccy order by key_date
            rows between unbounded preceding and current row
        ) as filledrate
    from
        joined_data
)

select
    key_date,
    from_ccy,
    to_ccy,
    filledrate as rate
from
    backfilled_data
qualify row_number() over (partition by from_ccy, to_ccy, key_date order by key_date desc) = 1
order by
    key_date desc
