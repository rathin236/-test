with

pivoted as (

    select
        key_date,
    {{ dbt_utils.pivot(
        'from_to_curr',
        dbt_utils.get_column_values(ref("int_currency_conversion__filtered"), 'from_to_curr'),
        agg='sum',
        then_value ='rate'
    ) }}
    from {{ ref("int_currency_conversion__filtered") }}
    group by key_date

),

date_spine as (
-- noqa: disable=PRS
    {{ dbt_utils.date_spine( 
        datepart="day",
        start_date="cast('2019-01-01' as date)",
        end_date="cast(current_date() + 365 + 365 as date)" 
        )
    }}

),
-- noqa: enable=all

joined as (

    select

        date_day,
        key_date,
        usd_cad,
        eur_usd,
        jpy_usd

    from date_spine
    left outer join pivoted on date_day = key_date
    order by date_day
),


imputed as (

    select

        date_day,
        coalesce(key_date, lag(key_date) ignore nulls over (order by date_day)) as date_effective,
        coalesce(usd_cad, lag(usd_cad) ignore nulls over (order by date_day)) as usd_cad,
        coalesce(eur_usd, lag(eur_usd) ignore nulls over (order by date_day)) as eur_usd,
        coalesce(jpy_usd, lag(jpy_usd) ignore nulls over (order by date_day)) as jpy_usd

    from joined

),

filtered as (

    select * from imputed where year(date_day) >= 2020

),

-- take inverse of usd_cad for cad_usd
inversed as (

    select

        date_day,
        date_effective,
        (1 / usd_cad) as cad_usd,
        eur_usd,
        jpy_usd

    from filtered
)

select * from inversed
