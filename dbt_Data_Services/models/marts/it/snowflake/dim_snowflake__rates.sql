with rates as (

    select * from {{ ref('int_usage_rates') }}

),

conversion as (

    select * from {{ ref('dim_exchange_rates') }}
),

conversion_joined as (

    select

        rates.date,
        rates.contract_number,
        rates.usage_type,
        rates.service_type,
        rates.effective_rate,
        rates.currency,
        conversion.rate as usd_to_cad_rate

    from rates

    left join conversion on rates.date = conversion.fx_date

    where conversion.from_ccy = 'USD' and conversion.to_ccy = 'CAD'

),

converted as (

    select

        date as rate_date,
        contract_number,
        usage_type,
        service_type,
        (effective_rate * usd_to_cad_rate) as effective_rate_cad

    from conversion_joined

),

pivoted as (

    select
        rate_date,
        contract_number,
        max(case when usage_type = 'compute' then effective_rate_cad end) as compute_rate,
        max(case when usage_type = 'storage' then effective_rate_cad end) as storage_rate
    -- Add more lines for each unique usage_type

    from converted
    where rate_date > '2022-10-31'
    group by rate_date, contract_number

)

select * from pivoted
