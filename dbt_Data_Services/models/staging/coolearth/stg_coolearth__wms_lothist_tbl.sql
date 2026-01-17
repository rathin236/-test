with source as (
    select {{ convert_columns('coolearth', 'wms_lothist_tbl') }}
    from {{ source('coolearth', 'wms_lothist_tbl') }}
),

renamed as (
    select
        wms_lothist_id,
        track_input_method,
        im_pack_key,
        wms_tran_type,
        wms_tran_key,
        wms_contdtl_key,
        in_lot_key,
        result_qty,
        trans_desc,
        dbserverdatetime,
        wms_lothist_uom,
        sa_user_key,
        item_desc,
        comment_key,
        in_item_key,
        gl_cmp_key,
        wms_conthdr_key,
        wms_lothist_crtdt,
        wms_lothist_qty,
        transact_qty,
        bin,
        in_whs_key,
        _fivetran_deleted,
        _fivetran_synced
    from source
)

select * from renamed
where coalesce(_fivetran_deleted, 'FALSE') = 'FALSE'
