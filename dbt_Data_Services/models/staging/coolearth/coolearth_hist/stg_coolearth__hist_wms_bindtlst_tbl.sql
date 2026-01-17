with source as (
    select
        {{ convert_columns('coolearth_hist', 'wms_bindtlst_tbl') }}
    from {{ source('coolearth_hist', 'wms_bindtlst_tbl') }}
),

renamed as (
    select
        gl_cmp_key,
        in_whs_key,
        wms_bin_key,
        wms_contdtl_key,
        wms_conthdr_key,
        wms_bin_height,
        wms_count_key,
        dont_trackvol,
        wms_bin_width,
        wms_contdtl_own,
        lastcount,
        wms_conthdr_lstmv,
        wms_count_status,
        wms_count_qty,
        wms_contdtl_qty,
        wms_bin_depth,
        wms_binst_pc,
        not_on_picklist,
        dbserverdatetime,
        wms_count_var,
        wms_contst_key,
        wms_bindtlst_tbl_id,
        volumetracked,
        in_item_key,
        wms_contdtl_puldt,
        wms_bin_vol,
        im_pack_key,
        wms_contdtl_alloc,
        wms_binst_rem,
        wms_zone_key,
        in_lot_key,
        wms_bin_type,
        pickable,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active
    from source
)

select * from renamed
