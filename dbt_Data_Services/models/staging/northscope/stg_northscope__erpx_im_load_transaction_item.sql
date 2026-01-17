with source as (

    select * from {{ source('northscope', 'erpx_lmloadtransactionitem') }}

),

renamed as (

    select
        additionalweight,
        transactionmodulesk,
        deliverycharge,
        othercharge,
        totalfreight,
        lastuser,
        dataentitycompanysk,
        orderitemsk,
        surcharge,
        loadtransactionitemsk,
        loadtransactionsk,
        loadheadersk,
        lastupdated,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
