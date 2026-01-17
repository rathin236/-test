with source as (

    select * from {{ source('coolearth', 'wms_bindtlst_tbl') }}

),

renamed as (

    select
        wms_contdtl_key,
        wms_count_qty,
        wms_binst_pc,
        wms_bindtlst_tbl_id,
        wms_bin_key,
        wms_conthdr_key,
        im_pack_key,
        wms_bin_width,
        wms_count_status,
        wms_contdtl_qty,
        pickable,
        wms_conthdr_lstmv,
        wms_bin_depth,
        wms_bin_height,
        lastcount,
        in_item_key,
        wms_contst_key,
        wms_count_var,
        in_lot_key,
        volumetracked,
        wms_bin_type,
        wms_count_key,
        gl_cmp_key,
        dbserverdatetime,
        in_whs_key,
        wms_contdtl_alloc,
        wms_contdtl_own,
        wms_contdtl_puldt,
        wms_zone_key,
        wms_binst_rem,
        not_on_picklist,
        wms_bin_vol,
        dont_trackvol,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
