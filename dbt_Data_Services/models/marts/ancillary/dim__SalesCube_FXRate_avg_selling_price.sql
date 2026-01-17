/*******************************************************************************************************************************************
     This model has exchange rates for these currencies - USD, CAD, CLP, JPY, EUR, GBP

     It is specifically designed to feed in exchange rates to the sales cube for the average selling price report
*******************************************************************************************************************************************/

with exchange_rates as (
    select * from {{ ref("int_ancillary__daily_exchange_rates_multi_currency") }}
    where datediff(day, '2024-05-29', RateDate) % 7 = 0
),

rates_updated as (
    select
        coalesce(cpm.mapped_currency_pair, brt.from_ccy) as CurrencyPair,
        coalesce(cpm.mapped_ticker, brt.to_ccy) as Ticker,
        brt.RateDate,
        brt.Rate
    from exchange_rates brt
    left join {{ ref('ancillary__currency_pair_mapping') }} cpm 
        on brt.from_ccy = cpm.from_currency and brt.to_ccy = cpm.to_currency
)

select * from rates_updated