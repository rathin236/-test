with source as (

    select * from {{ source('coolearth_sb1', 'wms_contty_tbl') }}

),

renamed as (

    select
        wms_contty_case,
        wms_contty_lay,
        wms_contty_width,
        casegrosstype,
        wms_contty_uom,
        casegrosstare,
        wms_contty_dftrty,
        wms_contty_height,
        wms_contty_dftrtype,
        containertare,
        wms_contty_depth,
        wms_contty_tbl_id,
        dbserverdatetime,
        _fivetran_deleted,
        _fivetran_synced,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(wms_contty_key) as wms_contty_key,
        trim(in_whs_key) as in_whs_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
