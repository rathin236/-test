with sender_group as (
    select distinct

        'COOKE' as client_id,
        company.companyid as source,
        soh.orderid as order_id,
        to_date(soh.actualshipdate) as date_created

    from {{ ref('stg_northscope__erpx_so_order_header') }} as soh

    inner join {{ ref('stg_northscope__erpx_mf_data_entity_company') }} as company
        on soh.dataentitycompanysk = company.dataentitycompanysk

    inner join {{ ref('stg_coolearth__wms_outint_tbl') }} as oit
        on soh.orderid = oit.so_hdr_key

    inner join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caa
        on caa.customeraddresssk = soh.shipaddresssk
            and caa.dataentitycompanysk = soh.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue

)

select * from sender_group

/* For testing */
-- where order_id = 'AFO026562'
