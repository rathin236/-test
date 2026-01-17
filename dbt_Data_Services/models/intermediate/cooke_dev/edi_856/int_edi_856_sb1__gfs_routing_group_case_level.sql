with routing_group_case_level as (
    select

        soh.orderid as order_id,
        cdt.in_whs_key,
        cdt.wms_conthdr_key,
        cdt.in_desc,
        cct.wms_contcase_key,
        cct.wms_contcase_prddt,
        cct.lot,
        cdt.wms_contdtl_prddt,
        1 as contcase_qty,
        cct.pieces,
        cct.wms_contcase_ctwgt as catchweight,
        cct.wms_contcase_uom,
        car.carriername as carrier_name,
        mfav.attributevalue as direct_to_store,
        cdt.wms_contdtl_uom,
        iav."Category" as ccat,
        cus.customername,
        cct.wms_contcase_orgwhs,
        trim(cht.wms_bin_key) as wms_bin_key,
        trim(cdt.in_item_key) as in_item_key,
        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) as sonumber,
        case
            when cct.wms_contcase_uom = 'LB' then cct.wms_contcase_ctwgt
            when cct.wms_contcase_uom = 'KG' then cct.wms_contcase_ctwgt * 2.20462
            else cct.wms_contcase_ctwgt
        end as catchweight_lb,
        case
            when cct.wms_contcase_orgwhs in ('FBD', 'HERM', 'BLKS', 'NFLD')
                then 'Canada'
            when cct.wms_contcase_orgwhs in ('MACH', 'SUFF')
                then 'U.S.A.'
        end as country_of_mfg,
        case
            when cct.wms_contcase_uom = 'LB' then cct.wms_contcase_ctwgt / 2.20462
            when cct.wms_contcase_uom = 'KG' then cct.wms_contcase_ctwgt
            else cct.wms_contcase_ctwgt
        end as catchweight_kg,
        sum(cdt.wms_contdtl_qty) as wms_contdtl_qty

    from {{ ref('stg_coolearth_sb1__wms_contcase_tbl') }} as cct

    inner join {{ ref('stg_coolearth_sb1__wms_contdtl_tbl') }} as cdt
        on cct.wms_conthdr_key = cdt.wms_conthdr_key
            and cct.wms_contdtl_key = cdt.wms_contdtl_key

    inner join {{ ref('stg_coolearth_sb1__wms_conthdr_tbl') }} as cht
        on cdt.wms_conthdr_key = cht.wms_conthdr_key
            and cdt.gl_cmp_key = cht.gl_cmp_key
            and cdt.in_whs_key = cht.in_whs_key
            and cht.wms_bin_key = 'SHIPPED'

    inner join {{ ref('item_attribute_values_sb1') }} as iav
        on cdt.in_item_key = iav.item_id
            and iav.dataentitycompany_sk = 1

    inner join {{ ref('stg_northscope_sb1__erpx_so_order_header') }} as soh
        on substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) = soh.orderid

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer') }} as cus
        on soh.customersk = cus.customersk

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address') }} as cusad
        on soh.shipaddresssk = cusad.customeraddresssk
            and soh.dataentitycompanysk = cusad.dataentitycompanysk

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_address_attribute') }} as caa
        on cusad.customeraddresssk = caa.customeraddresssk
            and caa.attributesk = '{{ var("edi_856_type") }}'

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address_attribute') }} as caaedi
        on soh.shipaddresssk = caaedi.customeraddresssk
            and soh.dataentitycompanysk = caaedi.dataentitycompanysk
            and caaedi.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    left join {{ ref('stg_northscope_sb1__erpx_mf_attribute_value') }} as mfav
        on caa.attributevalue = mfav.attributevaluesk
            and mfav.attributesk = '{{ var("edi_856_type") }}'

    inner join {{ ref('stg_northscope_sb1__erpx_so_carrier') }} as car
        on soh.carriersk = car.carriersk
            and soh.dataentitycompanysk = car.dataentitycompanysk

    where caaedi.attributevalue < current_date()
        and caaedi.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caaedi.attributevalue -- noqa: disable=PRS

    group by all
    -- noqa: enable=PRS
)

select

    sum(catchweight_kg)::float as shipment_net_weight_kg,
    sum(catchweight_lb)::float as shipment_net_weight_lb,
    sum(catchweight_kg)::float as shipment_gross_weight_kg,
    sum(catchweight_lb)::float as shipment_gross_weight_lb,
    null as shipment_volume,
    null as volume_uom,
    '' as routing_seq_code,
    2 as id_code_qual,
    'SCAC' as id_code,
    carrier_name as routing,
    'FOB1' as fob,
    sonumber as order_id,
    'M' as trans_type_code,
    count(distinct wms_conthdr_key) as number_of_pallets,
    sum(contcase_qty) as number_of_cases,
    case
        when direct_to_store = 'Yes' then 'CTN25'
        else 'PLT94'
    end as packaging_code

from routing_group_case_level

/* For Testing */
-- where order_id like '%TNS122272%'

group by
    carrier_name,
    sonumber,
    direct_to_store
