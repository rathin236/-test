with source as (

    select * from {{ source('coolearth', 'wms_piint_tbl') }}

),

renamed as (

    select
        shortage,
        wms_piint_bqty,
        pieces,
        wms_piint_crdt,
        wms_piint_finalpr,
        wms_contdtl_puldt,
        wms_piint_sqty,
        workorder,
        sa_user_key,
        in_locn_key,
        pm_matl_key,
        dbserverdatetime,
        wms_piint_error,
        wms_piint_control,
        sf_opseq_key,
        wms_piint_ctwgt,
        trankey,
        pm_shop_ordtp,
        wms_piint_labhr,
        alterpuldt,
        wms_piint_inedible,
        wms_piint_waste,
        im_pack_key,
        wms_piint_reason,
        origintrack,
        trans_date,
        wms_batch_id,
        wms_piint_id,
        wms_shift_key,
        outputlot,
        _fivetran_deleted,
        _fivetran_synced,
        trim(wms_ctwgt_uom) as wms_ctwgt_uom,
        trim(wms_piint_uom) as wms_piint_uom,
        trim(wms_line_key) as wms_line_key,
        trim(sf_plant_key) as sf_plant_key,
        trim(wms_contdtl_key) as wms_contdtl_key,
        trim(in_lot_key) as in_lot_key,
        trim(pm_shop_key) as pm_shop_key,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(in_item_key) as in_item_key,
        trim(wms_conthdr_key) as wms_conthdr_key,
        trim(in_whs_key) as in_whs_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
