with

source as (

    select * from {{ source('northscope', 'erpx_mfsite') }}

),

renamed as (

    select
        productionbatchprefix,
        createdby,
        fax,
        isvisibletosales,
        siteid,
        sitesk,
        addressline2,
        allowdefaultwarehouselotfromtransferreceipt,
        lastupdated,
        isintransit,
        phone1,
        sitename,
        warehouselottemplate,
        isvisibletowms,
        email,
        lastuser,
        issitewarehouselottracked,
        assignwarehouselotsontransferreceipts,
        integratedtransferdefaultviasitesk,
        nextproductionbatchnumber,
        city,
        zip,
        isvisibletologistics,
        searchtext,
        isinactive,
        state,
        registration,
        country,
        createddatetime,
        dataentitycompanysk,
        addressline1,
        vendorsk,
        _fivetran_deleted,
        _fivetran_synced,
        trim(hostsystemlink) as hostsystemlink

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
