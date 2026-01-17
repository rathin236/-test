with

source as (

    select * from {{ source('innova_fbdag', 'base_devices') }}

),

renamed as (

    select
        device,
        weightres2,
        weightmax1,
        weightunit,
        description8,
        dimension2,
        description5,
        program,
        description2,
        wsserver,
        router,
        itgrsite,
        parentdevice,
        modified,
        address,
        dimension3,
        description6,
        created,
        modifiedby,
        devicetyped,
        code,
        name,
        objecttemplate,
        createdby,
        pattern,
        interfacetype,
        interfacespec,
        description3,
        shname,
        weightres1,
        weightmax2,
        driverassembly,
        drivertypename,
        active,
        description4,
        devicetype,
        description1,
        dimension1,
        dimension4,
        description7,
        extcode,
        cast("CONNECTION" as varchar) as device_connection,
        itgrstatus,
        codepage,
        equipmentsequence,
        xmldata,
        serial,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
