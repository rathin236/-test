with source as (

    select * from {{ source('coolearth_sb1', 'wms_pmint_tbl') }}

),

renamed as (

    select
        pm_shop_ordtp,
        sa_user_key,
        wms_pmint_sqty,
        wms_pmint_control,
        trans_date,
        backflushtxguid,
        wms_pmint_uom,
        wms_pmint_crdt,
        wms_pmint_reason,
        wms_batch_id,
        wms_pmintl_id,
        pieces,
        trankey,
        dbserverdatetime,
        backflushstatus,
        wms_pmint_error,
        wms_pmint_bqty,
        _fivetran_deleted,
        _fivetran_synced,
        trim(in_item_key) as in_item_key,
        trim(wms_conthdr_key) as wms_conthdr_key,
        trim(wms_contdtl_key) as wms_contdtl_key,
        trim(in_lot_key) as in_lot_key,
        trim(sf_plant_key) as sf_plant_key,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(wms_line_key) as wms_line_key,
        trim(pm_shop_key) as pm_shop_key,
        trim(im_pack_key) as im_pack_key,
        trim(in_whs_key) as in_whs_key,
        trim(wms_shift_key) as wms_shift_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
