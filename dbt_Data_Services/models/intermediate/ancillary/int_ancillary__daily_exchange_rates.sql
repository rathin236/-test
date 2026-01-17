with calendar as (
    select * from {{ ref('stg_ancillary__calendar') }}
),

currency_exchange_rates as (
    select * from {{ ref('stg_staging_prod_xref__currency_exchange_rates') }}
),

daily_exchange_rates as (
    /***** This section is doing all dates for USD to CAD *****/
    select

        dat."Key_Date" as fx_date,
        to_char(coalesce(forx.fxpair_id, coalesce(forx.fxpair_id, lag(forx.fxpair_id) ignore nulls over (order by dat."Key_Date" asc)))) as fxpair_id,
        coalesce(forx.rate, coalesce(forx.rate, lag(forx.rate) ignore nulls over (order by dat."Key_Date" asc))) as rate,
        coalesce(forx.from_ccy, coalesce(forx.from_ccy, lag(forx.from_ccy) ignore nulls over (order by dat."Key_Date" asc))) as from_ccy,
        coalesce(forx.to_ccy, coalesce(forx.to_ccy, lag(forx.to_ccy) ignore nulls over (order by dat."Key_Date" asc))) as to_ccy,
        coalesce(forx.effective_start, coalesce(forx.effective_start, lag(forx.effective_start) ignore nulls over (order by dat."Key_Date" asc)))
            as effective_start,
        coalesce(forx.effective_stop, coalesce(forx.effective_stop, lag(forx.effective_stop) ignore nulls over (order by dat."Key_Date" asc)))
            as effective_stop

    from calendar as dat

    left join currency_exchange_rates as forx
        on dat."Key_Date" = to_date(forx.effective_start)
            and forx.from_ccy = 'USD' and forx.to_ccy = 'CAD'

    where dat."Key_Date" >= '2017-01-01'

    union all

    /***** This section is doing all dates for CAD to USD *****/
    /***** There is a complication here where we're calculating the rate by using the reciporical of the USD to CAD rate *****/
    select

        dat."Key_Date" as fx_date,
        to_char(coalesce(forx.fxpair_id, coalesce(forx.fxpair_id, lag(forx.fxpair_id) ignore nulls over (order by dat."Key_Date" asc)))) as fxpair_id,
        1 / (coalesce(forx.rate, coalesce(forx.rate, lag(forx.rate) ignore nulls over (order by dat."Key_Date" asc)))) as rate,
        'CAD' as from_ccy,
        'USD' as to_ccy,
        coalesce(forx.effective_start, coalesce(forx.effective_start, lag(forx.effective_start) ignore nulls over (order by dat."Key_Date" asc)))
            as effective_start,
        coalesce(forx.effective_stop, coalesce(forx.effective_stop, lag(forx.effective_stop) ignore nulls over (order by dat."Key_Date" asc)))
            as effective_stop

    from calendar as dat

    left join currency_exchange_rates as forx
        on dat."Key_Date" = to_date(forx.effective_start)
            and forx.from_ccy = 'USD' and forx.to_ccy = 'CAD'

    where dat."Key_Date" >= '2017-01-01'

    union all

    /***** This section is doing all dates for CAD to CAD *****/
    select

        dat."Key_Date" as fx_date,
        to_char('CAD' || row_number() over (order by dat."Key_Date")) as fxpair_id,
        1 as rate,
        'CAD' as from_ccy,
        'CAD' as to_ccy,
        dat."Key_Date" as effective_start,
        dat."Key_Date" as effective_stop

    from calendar as dat

    where dat."Key_Date" >= '2017-01-01'

    union all

    /***** This section is doing all dates for USD to USD *****/
    select

        dat."Key_Date" as fx_date,
        to_char('USD' || row_number() over (order by dat."Key_Date")) as fxpair_id,
        1 as rate,
        'USD' as from_ccy,
        'USD' as to_ccy,
        dat."Key_Date" as effective_start,
        dat."Key_Date" as effective_stop

    from calendar as dat

    where dat."Key_Date" >= '2017-01-01'
)

select * from daily_exchange_rates
