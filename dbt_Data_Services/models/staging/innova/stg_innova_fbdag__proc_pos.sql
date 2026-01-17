with

source as (

    select * from {{ source('innova_fbdag', 'proc_pos') }}

),

renamed as (

    select
        ricountry3,
        dimension1,
        transporter,
        dtmark,
        dimension4,
        processor2,
        description5,
        inventory,
        description2,
        extcode,
        entryport,
        slhouse,
        pattern,
        brcountry,
        description8,
        validfrom,
        active,
        description6,
        departureport,
        code,
        lastday,
        objecttemplate,
        modifiedby,
        ricountry2,
        processor,
        matpricelist,
        deliverytime,
        slday,
        description7,
        producer,
        description4,
        description1,
        storage,
        accepttype,
        validto,
        deliverystatus,
        dimension2,
        dimension3,
        ricountry,
        shipment,
        itgrsite,
        description3,
        createdby,
        supplier,
        firstday,
        ricountry4,
        xmldata,
        created,
        owner,
        ricountry5,
        name,
        itgrstatus,
        shname,
        modified,
        po,
        allowadd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
