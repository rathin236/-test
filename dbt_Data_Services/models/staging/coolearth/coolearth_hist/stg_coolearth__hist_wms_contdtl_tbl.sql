with source as (
    select *
    from {{ source('coolearth_hist', 'wms_contdtl_tbl') }}
),

trimmed as (
    select {{ convert_columns('coolearth_hist', 'wms_contdtl_tbl') }}
    from source
),

renamed as (
    select
        gl_cmp_key,
        in_whs_key,
        wms_contdtl_key,
        wms_conthdr_key,
        wms_user_paramvc1,
        vendor_lot,
        wms_contdtl_puldt,
        wms_user_paramf5,
        wms_contst_key,
        wms_user_paramf2,
        wms_contdtl_coo,
        wms_user_paramf1,
        wms_user_paramf4,
        wms_user_paramf3,
        wms_user_paramf6,
        im_pack_key,
        wms_contdtl_kildt,
        wms_contdtl_opallet,
        wms_contdtl_prddt,
        wms_contdtl_item,
        wms_contdtl_country,
        wms_contdtl_ctwgt,
        wms_contdtl_crtdt,
        wms_contdtl_qty,
        wms_contdtl_own,
        wms_user_paramvc9,
        in_item_key,
        in_desc,
        wms_contdtl_tbl_id,
        wms_contdtl_alloc,
        in_lot_key,
        dbserverdatetime,
        wms_contdtl_vol,
        wms_contdtl_uom,
        wms_user_paramvc10,
        wms_contcase_uom,
        wms_user_paramvc6,
        so_prod_key,
        wms_user_paramvc3,
        wms_user_paramvc5,
        wms_user_paramvc2,
        wms_user_paramvc8,
        wms_user_paramvc7,
        wms_user_paramvc4,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active

    from trimmed
)

select * from renamed
