with fbd_line_temps as (

    select * from {{ ref('stg_inspec_fbd__qcfbdlinetemperatures') }}

),

filtered as (

    select * from fbd_line_temps
    where status_workflow = 'Finished'

),

transformed as (

    select

        _id as form_id,
        officialtime as created_at,
        productinformation_lot as lot_id,
        productiontemperatures_receivingline1,
        productiontemperatures_receivingline2,
        productiontemperatures_dawateringtank1,
        productiontemperatures_dewateringtank2,
        productiontemperatures_trimmingline1,
        productiontemperatures_trimmingline2,
        productiontemperatures_pinboningline1,
        productiontemperatures_pinboningline2,
        productiontemperatures_gradingline1,
        productiontemperatures_gradingline2,
        productiontemperatures_portions,
        productiontemperatures_traypack,
        productiontemperatures_wipinthevacooler,
        processingroomtemperatures_mainprocessingdeheading,
        processingroomtemperatures_mainprocessingpinboneline,
        processingroomtemperatures_mainprocessingpackagingarea,
        processingroomtemperatures_receiving1,
        processingroomtemperatures_portiontraypackroom,
        processingroomtemperatures_vacooler,
        processingroomtemperatures_shippingcooler,
        processingroomtemperatures_coldstorage,
        processingroomtemperatures_frozenarea,
        context_plant as facility,
        processingroomtemperatures_blastfreezer

    from filtered

),

organized as (

    select

        --pk
        form_id,

        --fk
        lot_id,

        --details

        ----strings
        facility,

        ----numerics
        ---- production temperatures
        -- receiving line 1 
        productiontemperatures_receivingline1,
        -- receiving line 2
        productiontemperatures_receivingline2,
        -- dewatering tank line 1
        productiontemperatures_dawateringtank1,
        -- dewatering tank line 2
        productiontemperatures_dewateringtank2,
        -- trimming line 1
        productiontemperatures_trimmingline1,
        -- trimming line 2
        productiontemperatures_trimmingline2,
        -- pin boning line 1
        productiontemperatures_pinboningline1,
        -- pin boning line 2
        productiontemperatures_pinboningline2,
        -- grading line 1
        productiontemperatures_gradingline1,
        -- gradning line 2
        productiontemperatures_gradingline2,
        -- portions
        productiontemperatures_portions,
        -- tray pack
        productiontemperatures_traypack,
        -- wip in the va cooler
        productiontemperatures_wipinthevacooler,
        ---- room temperatures
        -- main processing @ deheading
        processingroomtemperatures_mainprocessingdeheading,
        -- main processing @pinbone
        processingroomtemperatures_mainprocessingpinboneline,
        --main processing @ packaging
        processingroomtemperatures_mainprocessingpackagingarea,
        -- receiving
        processingroomtemperatures_receiving1,
        -- portion tray pack room
        processingroomtemperatures_portiontraypackroom,
        -- va cooler
        processingroomtemperatures_vacooler,
        -- shipping cooler
        processingroomtemperatures_shippingcooler,
        -- cold storage 
        processingroomtemperatures_coldstorage,
        -- frozen room
        processingroomtemperatures_frozenarea,
        -- blast freezer
        processingroomtemperatures_blastfreezer,

        ----booleans

        ----dates

        ----timestamps
        created_at

        --metadata

    from transformed

)

select * from organized
