with ub_data as (
    select
        marketdata_quotedate as quote_date,
        comcode as ub_code,
        marketdata_high as ub_price_high,
        marketdata_low as ub_price_low,
        marketdata_savg as ub_price_avg,
        currency as ub_currency,
        dateadd(day, 1, lag(marketdata_quotedate, -1) over (partition by comcode order by marketdata_quotedate desc))
            as previous_quote_date
    from {{ ref('stg_urnerbarry__my_items') }}

    where marketdata_savg is not null
),

northscope_ub_link as (
    select
        ub_code,
        trim(item_id) as item_id,
        trim(item_sk) as item_sk
    from {{ ref('stg_coolearth__vwx_imitemattributevalues') }}
)

select
    northscope_ub_link.item_id,
    northscope_ub_link.item_sk,
    cast(ub_data.quote_date as date) as quote_date,
    cast(ub_data.previous_quote_date as date) as previous_quote_date,
    ub_data.ub_code,
    ub_data.ub_price_high,
    ub_data.ub_price_low,
    ub_data.ub_price_avg,
    ub_data.ub_currency

from ub_data

inner join northscope_ub_link
    on ub_data.ub_code = northscope_ub_link.ub_code

/* For Testing */
{# where item_sk = '6139'
and quote_date <= '2021-04-30' and quote_date >= '2021-04-01'
order by quote_date #}
