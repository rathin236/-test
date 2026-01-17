/*******************************************************************************************************************************************
    This model has exchange rates for these currencies - USD, CAD, CLP, JPY, EUR, GBP

    These are exchange all rates till nov 11, 2023 (All Rates)

    After that we stopped recieving from CLP to other currencies
*******************************************************************************************************************************************/

with all_rates as (
    select
        from_ccy,
        to_ccy,
        key_date as ratedate,
        rate
    from {{ ref('stg_staging_prod_xref__currency_exchange_rates') }}
    where key_date < '2023-11-10' and key_date > '2018-12-31'
        and from_ccy in ('JPY', 'CAD', 'CLP', 'EUR', 'USD', 'GBP')
        and to_ccy in ('JPY', 'CAD', 'CLP', 'EUR', 'USD', 'GBP')
),

/*******************************************************************************************************************************************
    These are exchange all rates after nov 11, 2023

    we will use this to calculate missing currencies (USD to CLP)
*******************************************************************************************************************************************/

bank_rates as (
    select distinct
        from_ccy,
        to_ccy,
        key_date as ratedate,
        rate
    from {{ ref('stg_staging_prod_xref__currency_exchange_rates') }}
    where key_date > '2023-11-10'
        and from_ccy in ('JPY', 'CAD', 'CLP', 'EUR', 'USD', 'GBP')
        and to_ccy in ('JPY', 'CAD', 'CLP', 'EUR', 'USD', 'GBP')
),

/*******************************************************************************************************************************************
    identifying the rates between CLP and USD and using it to calculate exchange rates for other currencies
*******************************************************************************************************************************************/

usd_to_clp as (
    select distinct *
    from bank_rates
    where ratedate > '2023-11-10'
        and to_ccy = 'CLP'
        and from_ccy = 'USD'
),

calculated_inverse as (
    select
        'CLP' as from_ccy,
        case
            when brt.from_ccy = 'CAD' then 'CAD'
            when brt.from_ccy = 'GBP' then 'GBP'
            when brt.from_ccy = 'JPY' then 'JPY'
            when brt.from_ccy = 'EUR' then 'EUR'
            else brt.from_ccy
        end as to_ccy,
        brt.ratedate,
        round(1 / (brt.rate * u2c.rate), 5) as rate
    from bank_rates as brt
    inner join usd_to_clp as u2c
        on brt.ratedate = u2c.ratedate
    where brt.to_ccy = 'USD'
),

calculated_rates as (
    select
        case
            when brt.from_ccy = 'CAD' then 'CAD'
            when brt.from_ccy = 'GBP' then 'GBP'
            when brt.from_ccy = 'JPY' then 'JPY'
            when brt.from_ccy = 'EUR' then 'EUR'
            else brt.from_ccy
        end as from_ccy,
        'CLP' as to_ccy,
        brt.ratedate,
        brt.rate * u2c.rate as rate
    from bank_rates as brt
    inner join usd_to_clp as u2c
        on brt.ratedate = u2c.ratedate
    where brt.to_ccy = 'USD'
),

rates_unioned as (
    select * from calculated_inverse
    where to_ccy <> from_ccy
    union distinct
    select * from calculated_rates
    where to_ccy <> from_ccy
    union distinct
    select * from bank_rates
    union distinct
    select * from all_rates
)

select * from rates_unioned
order by ratedate asc
