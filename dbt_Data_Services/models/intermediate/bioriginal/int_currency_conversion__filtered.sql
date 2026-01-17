with

conv as (

    select * from {{ ref("stg_staging_prod_xref__currency_exchange_rates") }}
),

filtered as (

    select

        rate,
        key_date,
        from_ccy || '_' || to_ccy as from_to_curr

    from conv

    where year(to_date(effective_start)) >= 2019
        and from_ccy in ('JPY', 'CAD', 'EUR', 'USD')
        and to_ccy in ('USD', 'CAD')
        and from_to_curr in ('JPY_USD', 'EUR_USD', 'USD_CAD')

)

select * from filtered
