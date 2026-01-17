with source as (

    select * from {{ source('coolearth_sb1', 'wms_outint_tbl') }}

),

renamed as (

    select
        wms_outint_id,
        wms_outint_error,
        so_ship_key,
        wms_outint_ctwgt,
        im_pack_key,
        wms_pmint_control,
        wms_piint_control,
        wms_ctwgt_uom,
        wms_outint_loadpos,
        wms_outint_qty,
        wms_outint_type,
        wms_whistle_recdt,
        so_ship_key1,
        wms_outint_crtdt,
        loadkey,
        originalbin,
        dbserverdatetime,
        wms_contdtl_key,
        outintkey,
        wms_outint_control,
        track_input_method,
        wms_outint_uom,
        originalwhs,
        sa_user_key,
        wms_outdtl_key,
        _fivetran_deleted,
        _fivetran_synced,
        trim(so_hdr_key) as so_hdr_key,
        trim(wms_conthdr_key) as wms_conthdr_key,
        trim(so_brnch_key) as so_brnch_key,
        trim(in_towhs_key) as in_towhs_key,
        trim(in_lot_key) as in_lot_key,
        trim(in_item_key) as in_item_key,
        trim(in_whs_key) as in_whs_key,
        trim(so_prod_key) as so_prod_key,
        trim(gl_cmp_key) as gl_cmp_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
