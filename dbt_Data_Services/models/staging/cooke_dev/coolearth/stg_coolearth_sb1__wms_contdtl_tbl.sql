with source as (

    select * from {{ source('coolearth_sb1', 'wms_contdtl_tbl') }}

),

renamed as (

    select
        wms_user_paramvc2,
        wms_contdtl_item,
        wms_user_paramvc5,
        wms_user_paramvc8,
        wms_user_paramf4,
        wms_contdtl_ctwgt,
        wms_user_paramvc4,
        wms_contdtl_tbl_id,
        in_desc,
        wms_user_paramvc7,
        wms_user_paramf3,
        wms_contdtl_opallet,
        wms_contdtl_crtdt,
        wms_user_paramvc1,
        dbserverdatetime,
        wms_contdtl_vol,
        wms_user_paramvc10,
        wms_user_paramf5,
        wms_user_paramf2,
        wms_contdtl_own,
        wms_contdtl_country,
        wms_contdtl_uom,
        wms_contdtl_puldt,
        wms_user_paramvc9,
        vendor_lot,
        wms_user_paramf1,
        wms_contdtl_coo,
        wms_user_paramvc3,
        wms_user_paramf6,
        wms_contdtl_prddt,
        wms_user_paramvc6,
        wms_contdtl_qty,
        wms_contcase_uom,
        wms_contdtl_kildt,
        _fivetran_deleted,
        _fivetran_synced,
        trim(im_pack_key) as im_pack_key,
        trim(wms_contdtl_alloc) as wms_contdtl_alloc,
        trim(in_item_key) as in_item_key,
        trim(in_whs_key) as in_whs_key,
        trim(wms_conthdr_key) as wms_conthdr_key,
        trim(in_lot_key) as in_lot_key,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(wms_contst_key) as wms_contst_key,
        trim(wms_contdtl_key) as wms_contdtl_key,
        trim(so_prod_key) as so_prod_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
