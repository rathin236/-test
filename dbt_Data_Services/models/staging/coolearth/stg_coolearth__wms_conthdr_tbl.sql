with source as (

    select * from {{ source('coolearth', 'wms_conthdr_tbl') }}

),

renamed as (

    select
        sa_user_key,
        wms_conthdr_vol,
        labelid,
        wms_conthdr_tbl_id,
        wms_conthdr_lstmv,
        dbserverdatetime,
        track_input_method,
        wms_conthdr_lstdt,
        wms_contst_reldt,
        lockcounter,
        _fivetran_deleted,
        _fivetran_synced,
        trim(wms_conthdr_key) as wms_conthdr_key,
        trim(wms_bin_key) as wms_bin_key,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(wms_group_key) as wms_group_key,
        trim(in_locn_key) as in_locn_key,
        trim(in_whs_key) as in_whs_key,
        trim(wms_contst_key) as wms_contst_key,
        trim(wms_contty_key) as wms_contty_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
