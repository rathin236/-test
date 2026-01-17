with

source as (

    select * from {{ source('northscope', 'erpx_soinvoiceheader') }}

),

renamed as (

    select
        gldate,
        invoiceheadersk,
        lastuser,
        dataentitycompanysk,
        orderheadersk,
        extendedamount,
        invoicedate,
        invoicedocumentfirstprintdate,
        invoicenumber,
        lastupdated,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
