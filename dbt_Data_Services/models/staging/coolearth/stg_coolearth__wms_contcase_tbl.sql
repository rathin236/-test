with source as (

    select * from {{ source('coolearth', 'wms_contcase_tbl') }}

),

renamed as (

    select
        dbserverdatetime,
        created_on,
        created_by,
        wms_contcase_ctwgt,
        wms_contcase_lbldt,
        pieces,
        receipttype,
        allocation,
        wms_contcase_tbl_id,
        wms_contcase_tare,
        wms_contcase_stat,
        changed_by,
        wms_contcase_acwgt,
        changed_on,
        wms_contcase_orgwhs,
        in_sublot_key,
        wms_contcase_prddt,
        wms_contcase_shipstatus,
        lock_count,
        userkey,
        _fivetran_deleted,
        _fivetran_synced,
        trim(linekey) as linekey,
        trim(lot) as lot,
        trim(wms_contcase_uom) as wms_contcase_uom,
        trim(wms_contcase_key) as wms_contcase_key,
        trim(gl_cmp_key) as gl_cmp_key,
        trim(in_whs_key) as in_whs_key,
        trim(wms_contdtl_key) as wms_contdtl_key,
        trim(wms_conthdr_key) as wms_conthdr_key

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
