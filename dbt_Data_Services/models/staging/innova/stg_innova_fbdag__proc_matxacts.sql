with source as (

    select * from {{ source('innova_fbdag', 'proc_matxacts') }}

),

renamed as (

    select
        id,
        cday,
        exday2,
        prperiodfrom,
        tolot,
        weight,
        pieces,
        counter,
        asecto,
        regtime,
        nominalu,
        pathnum,
        toplot,
        porderline,
        bomyield,
        rmarea,
        employee,
        sprperiodto,
        sprperiodfrom,
        lot,
        porder,
        frombatch,
        prperiodto,
        shiftto,
        shiftfrom,
        plot,
        asecfrom,
        xactpath,
        unitop,
        value,
        "ORDER",
        po,
        station,
        bomrtype,
        bom,
        frombom,
        material,
        nominal,
        artype,
        nregs,
        unitopxid,
        exday,
        currency,
        recordedby,
        tobom,
        item,
        sysprogram,
        fromplot,
        asecdev,
        pack,
        batch,
        fromlot,
        device,
        rstat,
        tobatch,
        rtype,
        prday,
        link,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
