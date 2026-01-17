with source as (

    select * from {{ source('northscope_sb1', 'erpx_arcustomeraddress') }}

),

renamed as (

    select
        customeraddresssk,
        fax,
        carriersk,
        insidesalespersonsk,
        attentionto,
        salespersonsk,
        customersk,
        isdefaultshiptoaddress,
        addressid,
        addressname,
        taxclasssk,
        createdby,
        addressline3,
        country,
        createddatetime,
        email,
        addresstypeen,
        pricelistheadersk,
        hostsystemlink,
        city,
        zip,
        sitesk,
        state,
        aritemaccessoptionen,
        sofreighttermsen,
        dataentitycompanysk,
        addressline2,
        lastupdated,
        attributeclasssk,
        sofreightprogramsen,
        phone1,
        lastuser,
        addressline1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
