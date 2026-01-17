with source as (

    select * from {{ source('northscope', 'erpx_arcustomeraddress') }}

),

renamed as (

    select
        fax,
        carriersk,
        insidesalespersonsk,
        attentionto,
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
        _fivetran_synced,
        trim(customeraddresssk) as customeraddresssk,
        trim(salespersonsk) as salespersonsk

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
