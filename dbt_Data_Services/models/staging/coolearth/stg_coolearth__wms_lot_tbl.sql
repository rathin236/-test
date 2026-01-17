with source as (

    select * from {{ source('coolearth', 'wms_lot_tbl') }}

),

renamed as (

    select
        en_item_key,
        en_lot_key,
        gl_cmp_key,
        cage,
        vessel,
        piececount,
        lotsource,
        guaranteedeclaration,
        juliandate,
        rcvdate,
        avgprocessedwgt,
        noshiplist,
        killdt_lstupdt,
        lotopen,
        product,
        openva,
        harvestdate,
        childguia,
        note,
        wms_lot_tbl_id,
        lotcreatedon,
        lotcreatedby,
        harvestid,
        productstate,
        tarewgt,
        grosswgt,
        casewgt,
        projwgtavg,
        originlot,
        lotlastmodifiedby,
        deliverynote,
        dbserverdatetime,
        motherguia,
        killdt_updt_by,
        openwf,
        julianyear,
        lotlastmodifiedon,
        owner,
        finishedgoodtype,
        certifications,
        countryoforigin,
        wms_lot_killdt,
        ponumber,
        printcerts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
