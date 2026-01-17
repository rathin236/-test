with source as (

    select * from {{ source('northscope', 'erpx_lmloadheader') }}

),

renamed as (

    select
        sofreighttermsen,
        loadguid,
        dischargedate,
        dataentitycompanysk,
        ordersaddedflag,
        trailer,
        additionalweight,
        bookingnumber,
        dischargeport,
        additionalfreight,
        buildloadmodulesk,
        forwarder,
        orderedpallets,
        loadidoverride,
        uomsk,
        shippingline,
        entryport,
        deliveryport,
        loadheadersk,
        vesselnumber,
        scheduleddeparturedate,
        palletsallowed,
        loadstatussk,
        entrydate,
        deliverydate,
        actualshipdate,
        scheduledarrivaltime,
        trucksk,
        totalfreight,
        loadid,
        emptyadditionalpallets,
        loadaddordersoptionsk,
        drivername,
        surcharge,
        carriersk,
        weightallowed,
        vessel,
        scheduledby,
        soordercount,
        actualarrivaldate,
        actualdeparturetime,
        sitesk,
        scheduledarrivaldate,
        freightratetypeen,
        lastuser,
        loadingport,
        attributeclasssk,
        loadingdate,
        freightrate,
        scheduleddeparturetime,
        actualarrivaltime,
        lastupdated,
        scheduledshipdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
