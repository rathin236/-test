with source as (

    select * from {{ source('fishtalk', 'feedreceptionbatches') }}

),

renamed as (

    select
        feedreceptionlinenumber,
        outofdate,
        suppliersbatchnumber,
        feedbatchid,
        currencyid,
        productiondate,
        receiptnumber,
        receptionamount,
        priceperkg,
        packingtypeid,
        _fivetran_deleted,
        _fivetran_synced,
        trim(feedreceptionid) as feedreceptionid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
