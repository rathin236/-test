with source as (

    select * from {{ source('coolearth_sb1', 'wmgiveaway') }}

),

renamed as (

    select
        track,
        graderweight,
        pack,
        packagingdate,
        disposition,
        productiondate,
        pieces,
        inventoryweight,
        scaletare,
        company,
        price,
        subcase,
        measuredweight,
        plant,
        item,
        comment,
        grosstare,
        proddateuser,
        version,
        proddatesource,
        grossscaleweight,
        linekey,
        labelblob,
        machine,
        uom,
        grossweight,
        warehouse,
        giveaway,
        lot,
        wmgiveaway_id,
        transactiontime,
        pulldate,
        productionorder,
        _fivetran_deleted,
        _fivetran_synced,
        trim(casenumber) as casenumber

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
