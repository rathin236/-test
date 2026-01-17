with

source as (

    select * from {{ source('northscope_sb1', 'erpx_mfsite') }}

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
        hostsystemlink,
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
        _fivetran_synced

    from source

)

select * from renamed
