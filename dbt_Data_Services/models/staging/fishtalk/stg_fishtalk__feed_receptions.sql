with source as (

    select * from {{ source('fishtalk', 'feedreceptions') }}

),

renamed as (

    select
        transportmethodid,
        feedmessageid,
        supplierid,
        ssccnumber,
        transportordernumber,
        transportdocumentnumber,
        ourreference,
        ordernumber,
        deliveryreasonsid,
        comment,
        receptiontime,
        transporterid,
        deliveryterms,
        deliverynotenumber,
        gtin,
        shippingdate,
        transportcarrierid,
        ourorderno,
        _fivetran_deleted,
        _fivetran_synced,
        trim(feedreceptionid) as feedreceptionid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
