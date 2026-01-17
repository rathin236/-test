with source as (

    select * from {{ source('coolearth', 'wms_pmintdtl_tbl') }}

),

renamed as (

    select
        wms_contcase_tare,
        wms_pmintdtl_id,
        dbserverdatetime,
        wms_contcase_ctwgt,
        wms_contcase_prddt,
        wms_contcase_acwgt,
        pieces,
        wms_pmintdtl_crtdt,
        _fivetran_deleted,
        _fivetran_synced,
        trim(wms_contcase_uom) as wms_contcase_uom,
        trim(in_sublot_key) as in_sublot_key,
        trim(pm_shop_key) as pm_shop_key,
        trim(wms_contcase_key) as wms_contcase_key,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(wms_contdtl_key) as wms_contdtl_key,
        trim(sf_plant_key) as sf_plant_key,
        trim(in_whs_key) as in_whs_key,
        trim(wms_conthdr_key) as wms_conthdr_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
