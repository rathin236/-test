with source as (

    select * from {{ source('view_src', 'urnerbarry_myitems') }}

),

renamed as (

    select
        insert_date,
        date_key,
        cat,
        comcode,
        currency,
        description,
        marketdata_high,
        marketdata_loads,
        marketdata_low,
        marketdata_marketintervaltypeid,
        marketdata_pounds,
        marketdata_quotedate,
        marketdata_savg,
        marketdata_trades,
        marketdata_weeknumber,
        marketdata_wtdavg,
        measurement,
        sortorder,
        source,
        subcategory

    from source

)

select * from renamed
