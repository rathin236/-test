with coolearth_tables as (
    select

        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) as order_id,
        count(cct.wms_contcase_key) as case_count

    from {{ ref('stg_coolearth__wms_contdtl_tbl') }} as cdt

    left join {{ ref('stg_coolearth__wms_contcase_tbl') }} as cct
        on cct.wms_conthdr_key = cdt.wms_conthdr_key
            and cct.wms_contdtl_key = cdt.wms_contdtl_key
            and cct.gl_cmp_key = cdt.gl_cmp_key
            and cct.in_whs_key = cdt.in_whs_key

    group by substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc))

),

header_group as (
    select

        'TN' as entity_id_code,
        soh.orderid as bol_number,
        soh.documentid as edi_division,
        soh.orderid as order_id,
        soh.actualshipdate,
        '00' as transaction_purpose,
        current_date() as asn_date,
        current_time() as asn_time,
        to_date(soh.actualshipdate) as ship_date,
        to_time(soh.actualshipdate) as ship_time,
        to_date(soh.scheduleddeliverydate) as delivery_date

    from {{ ref('stg_northscope__erpx_so_order_header') }} as soh

    inner join {{ ref('stg_northscope__erpx_ar_customer') }} as cus
        on soh.customersk = cus.customersk
            and soh.dataentitycompanysk = cus.dataentitycompanysk

    inner join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caa
        on caa.customeraddresssk = soh.shipaddresssk
            and caa.dataentitycompanysk = soh.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    left join coolearth_tables as cet
        on soh.orderid = cet.order_id

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue

)

select * from header_group

/* For Testing */
-- where order_id = 'AFO026562'
