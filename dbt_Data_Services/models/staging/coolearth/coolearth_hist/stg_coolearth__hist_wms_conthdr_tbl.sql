with source as (

    select {{ convert_columns('coolearth_hist', 'wms_conthdr_tbl') }}
    from {{ source('coolearth_hist', 'wms_conthdr_tbl') }}

),

renamed as (

    select
        gl_cmp_key,
        in_whs_key,
        wms_conthdr_key,
        wms_conthdr_vol,
        wms_conthdr_lstdt,
        wms_contty_key,
        wms_contst_key,
        wms_contst_reldt,
        wms_conthdr_tbl_id,
        wms_conthdr_lstmv,
        wms_group_key,
        dbserverdatetime,
        track_input_method,
        wms_bin_key,
        labelid,
        sa_user_key,
        in_locn_key,
        lockcounter,
        _fivetran_synced,
        _fivetran_start,
        _fivetran_end,
        _fivetran_active

    from source

)

select * from renamed
