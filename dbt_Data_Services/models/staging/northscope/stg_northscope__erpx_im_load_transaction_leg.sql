with source as (

    select * from {{ source('northscope', 'erpx_lmloadtransactionleg') }}

),

renamed as (

    select
        carriersk,
        currencysk,
        addressline2,
        lastuser,
        othercharges,
        freightrateuomsk,
        state,
        loadtransactionlegsourceen,
        exchangesk,
        loadtransactionsk,
        city,
        zip,
        freighttax,
        totalfreight,
        legsequence,
        externallegid,
        exchangerate,
        lastupdated,
        dataentitycompanysk,
        freightweight,
        country,
        addressline1,
        freightratetypeen,
        addressname,
        surcharge,
        externalloadid,
        isclosed,
        freightrate,
        exchangeratecalculationmethoden,
        isinverseexchange,
        loadtransactionlegsk,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
