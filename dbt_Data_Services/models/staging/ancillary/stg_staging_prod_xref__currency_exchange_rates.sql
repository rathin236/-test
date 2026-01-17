with source as (

    select * from {{ source('staging_prod', 'currency_exchange_rates') }}

),

renamed as (

    select
        fxpair_id,
        from_ccy,
        to_ccy,
        rate,
        trim(stage_date) as stage_date,
        trim(effective_start) as effective_start,
        trim(effective_stop) as effective_stop,
        trim(to_date(effective_start)) as key_date

    from source

)

select * from renamed
