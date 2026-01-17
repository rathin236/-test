with routing_group_raw_material as (
    select

        soh.orderid as order_id,
        cdt.in_whs_key,
        cdt.wms_conthdr_key,
        cdt.in_desc,
        'RM' as wms_contcase_key,
        cdt.wms_contdtl_prddt as wms_contcase_prddt,
        cdt.in_lot_key as lot,
        cdt.wms_contdtl_prddt,
        1 as contcase_qty,
        cdt.wms_user_paramvc1 as pieces,
        cdt.wms_contdtl_qty as catchweight,
        cdt.wms_contdtl_uom as wms_contcase_uom,
        car.carriername as carrier_name,
        mfav.attributevalue as direct_to_store,
        cdt.wms_contdtl_uom,
        iav."Category" as ccat,
        cus.customername,
        pmt.sf_plant_key as wms_contcase_orgwhs,
        cdt.wms_contdtl_qty,
        cdt.wms_contdtl_key,
        cv2.conversionvalue,
        trim(cht.wms_bin_key) as wms_bin_key,
        trim(cdt.in_item_key) as in_item_key,
        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) as sonumber,
        case
            when cdt.wms_contdtl_qty = 0
                then
                    case
                        when cdt.wms_contcase_uom = 'LB'
                            then cdt.wms_contdtl_ctwgt
                        when cdt.wms_contcase_uom = 'KG'
                            then cdt.wms_contdtl_ctwgt / 2.20462
                        else 0
                    end
            else (cdt.wms_contdtl_qty * cv2.conversionvalue) * 2.20462
        end as catchweight_lb,
        case
            when pmt.sf_plant_key in ('FBD', 'HERM', 'BLKS', 'NFLD')
                then 'Canada'
            when pmt.sf_plant_key in ('MACH', 'SUFF')
                then 'U.S.A.'
        end as country_of_mfg,
        case
            when cdt.wms_contdtl_qty = 0
                then
                    case
                        when cdt.wms_contcase_uom = 'LB'
                            then cdt.wms_contdtl_ctwgt * 2.20462
                        when cdt.wms_contcase_uom = 'KG'
                            then cdt.wms_contdtl_ctwgt
                        else 0
                    end
            else cdt.wms_contdtl_qty * cv2.conversionvalue
        end as catchweight_kg

    from {{ ref('stg_coolearth__wms_contdtl_tbl') }} as cdt

    left join {{ ref('stg_coolearth__wms_contcase_tbl') }} as cct
        on cdt.wms_conthdr_key = cct.wms_conthdr_key
            and cdt.wms_contdtl_key = cct.wms_contdtl_key

    inner join {{ ref('stg_coolearth__wms_conthdr_tbl') }} as cht
        on cdt.wms_conthdr_key = cht.wms_conthdr_key
            and cdt.gl_cmp_key = cht.gl_cmp_key
            and cdt.in_whs_key = cht.in_whs_key
            and cht.wms_bin_key = 'SHIPPED'

    inner join {{ ref('item_attribute_values') }} as iav
        on cdt.in_item_key = iav.item_id
            and iav.dataentitycompany_sk = 1

    inner join {{ ref('stg_northscope__erpx_so_order_header') }} as soh
        on substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) = soh.orderid

    inner join {{ ref('stg_northscope__erpx_ar_customer') }} as cus
        on soh.customersk = cus.customersk

    inner join {{ ref('stg_northscope__erpx_ar_customer_address') }} as cusad
        on soh.shipaddresssk = cusad.customeraddresssk
            and soh.dataentitycompanysk = cusad.dataentitycompanysk

    inner join {{ ref('stg_northscope__erpx_so_order_item') }} as soi
        on soh.dataentitycompanysk = soi.dataentitycompanysk
            and soh.orderheadersk = soi.orderheadersk

    inner join {{ ref('stg_northscope__erpx_im_item') }} as item
        on soh.dataentitycompanysk = item.dataentitycompanysk
            and cdt.in_item_key = item.itemid
            and soi.itemsk = item.itemsk

    left join {{ ref('stg_northscope__erpx_im_uom_schedule_conversion_value') }} as cv2
        on item.uomschedulesk = cv2.uomschedulesk
            and soi.unitsuomsk = cv2.fromuomsk
            and cv2.touomsk = '{{ var("edi_856_item_uom") }}'
            and item.dataentitycompanysk = cv2.dataentitycompanysk

    left join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caa
        on cusad.customeraddresssk = caa.customeraddresssk
            and caa.attributesk = '{{ var("edi_856_type") }}'

    inner join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caaedi
        on soh.shipaddresssk = caaedi.customeraddresssk
            and soh.dataentitycompanysk = caaedi.dataentitycompanysk
            and caaedi.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    left join {{ ref('stg_northscope__erpx_mf_attribute_value') }} as mfav
        on caa.attributevalue = mfav.attributevaluesk
            and mfav.attributesk = '{{ var("edi_856_type") }}'

    left join {{ ref('stg_coolearth__wms_pmint_tbl') }} as pmt
        on cdt.wms_conthdr_key = pmt.wms_conthdr_key

    inner join {{ ref('stg_northscope__erpx_so_carrier') }} as car
        on soh.carriersk = car.carriersk
            and soh.dataentitycompanysk = car.dataentitycompanysk

    where cct.wms_conthdr_key is null --this is an important line of code. We're saying, filter out any case level info
        and caaedi.attributevalue < current_date()
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
    sum(wms_contdtl_qty) as number_of_cases,
    case
        when direct_to_store = 'Yes' then 'CTN25'
        else 'PLT94'
    end as packaging_code

from routing_group_raw_material

/* For Testing */
-- where order_id like '%AFO026562%'

group by
    carrier_name,
    sonumber,
    direct_to_store
