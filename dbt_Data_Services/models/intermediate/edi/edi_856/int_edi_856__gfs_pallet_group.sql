with pallet_group as (
    -- Catchweight items
    select

        soh.orderid as order_id,
        cdt.in_whs_key,
        cdt.wms_conthdr_key,
        {{ sscc_header_item('cdt.wms_conthdr_key') }} as sscc,
        cdt.in_desc,
        cct.wms_contcase_key,
        cct.wms_contcase_prddt,
        cct.lot,
        cdt.wms_contdtl_prddt,
        1 as contcase_qty,
        cct.pieces,
        car.carriername as carrier_name,
        ctt.wms_contty_lay as pallet_layers,
        ctt.wms_contty_case as pallet_blocks,
        cct.wms_contcase_ctwgt as catchweight,
        cct.wms_contcase_uom,
        cdt.wms_contdtl_uom,
        iav."Category" as ccat,
        cus.customername as customer_name,
        cct.wms_contcase_orgwhs,
        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) as so_number,
        cht.wms_bin_key,
        cdt.in_item_key as cooke_item_id,
        cdt.wms_conthdr_key as pallet_id,
        case
            when cct.wms_contcase_uom = 'LB' then cct.wms_contcase_ctwgt
            when cct.wms_contcase_uom = 'KG' then cct.wms_contcase_ctwgt * 2.20462
            else cct.wms_contcase_ctwgt
        end as catchweight_lb,
        case
            when cct.wms_contcase_uom = 'LB' then cct.wms_contcase_ctwgt / 2.20462
            when cct.wms_contcase_uom = 'KG' then cct.wms_contcase_ctwgt
            else cct.wms_contcase_ctwgt
        end as catchweight_kg,
        sum(cdt.wms_contdtl_qty) as wms_contdtl_qty,
        case
            when cct.wms_contcase_orgwhs in ('FBD', 'HERM', 'BLKS', 'NFLD')
                then 'Canada'
            when cct.wms_contcase_orgwhs in ('MACH', 'SUFF')
                then 'U.S.A.'
        end as country_of_mfg

    from {{ ref('stg_coolearth__wms_contcase_tbl') }} as cct

    inner join {{ ref('stg_coolearth__wms_contdtl_tbl') }} as cdt
        on cct.wms_conthdr_key = cdt.wms_conthdr_key
            and cct.wms_contdtl_key = cdt.wms_contdtl_key
            and cct.gl_cmp_key = cdt.gl_cmp_key
            and cct.in_whs_key = cdt.in_whs_key

    inner join {{ ref('stg_coolearth__wms_conthdr_tbl') }} as cht
        on cdt.gl_cmp_key = cht.gl_cmp_key
            and cdt.in_whs_key = cht.in_whs_key
            and cdt.wms_conthdr_key = cht.wms_conthdr_key
            and cht.wms_bin_key = 'SHIPPED'

    inner join {{ ref('item_attribute_values') }} as iav
        on cdt.in_item_key = iav.item_id
            and iav.dataentitycompany_sk = 1

    inner join {{ ref('stg_northscope__erpx_so_order_header') }} as soh
        on substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) = soh.orderid

    inner join {{ ref('stg_northscope__erpx_ar_customer') }} as cus
        on soh.customersk = cus.customersk

    inner join {{ ref('stg_northscope__erpx_so_carrier') }} as car
        on soh.carriersk = car.carriersk
            and soh.dataentitycompanysk = car.dataentitycompanysk

    inner join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caa
        on soh.shipaddresssk = caa.customeraddresssk
            and soh.dataentitycompanysk = caa.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    inner join {{ ref('stg_coolearth__wms_contty_tbl') }} as ctt
        on cht.gl_cmp_key = ctt.gl_cmp_key
            and cht.wms_contty_key = ctt.wms_contty_key
            and cht.in_whs_key = ctt.in_whs_key

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue

    group by
        soh.orderid,
        cdt.in_whs_key,
        cdt.wms_conthdr_key,
        cdt.in_desc,
        cct.wms_contcase_key,
        cct.wms_contcase_prddt,
        cct.lot,
        cdt.wms_contdtl_prddt,
        cct.pieces,
        car.carriername,
        ctt.wms_contty_lay,
        ctt.wms_contty_case,
        cct.wms_contcase_ctwgt,
        cct.wms_contcase_uom,
        cdt.wms_contdtl_uom,
        iav."Category",
        cus.customername,
        cct.wms_contcase_orgwhs,
        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)),
        cht.wms_bin_key,
        cdt.in_item_key,
        cdt.in_lot_key,
        cdt.wms_contdtl_qty,
        cdt.wms_conthdr_key,
        cdt.wms_contcase_uom,
        cdt.wms_contdtl_ctwgt

    union all

    -- Fixed weight or weight only items
    select

        soh.orderid as order_id,
        cdt.in_whs_key,
        cdt.wms_conthdr_key,
        {{ sscc_header_item('cdt.wms_conthdr_key') }} as sscc,
        cdt.in_desc,
        'RM' as wms_contcase_key,
        cdt.wms_contdtl_prddt as wms_contcase_prddt,
        cdt.in_lot_key as lot,
        cdt.wms_contdtl_prddt,
        1 as contcase_qty,
        cdt.wms_user_paramvc1 as pieces,
        car.carriername as carrier_name,
        ctt.wms_contty_lay as pallet_layers,
        ctt.wms_contty_case as pallet_blocks,
        cdt.wms_contdtl_qty as catchweight,
        cdt.wms_contdtl_uom as wms_contcase_uom,
        cdt.wms_contdtl_uom,
        iav."Category" as ccat,
        cus.customername,
        pmt.sf_plant_key as wms_contcase_orgwhs,
        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) as so_number,
        trim(cht.wms_bin_key) as wms_bin_key,
        cdt.in_item_key as cooke_item_id,
        cdt.wms_conthdr_key as pallet_id,
        case
            when cdt.wms_contdtl_qty = 0
                then
                    case
                        when cdt.wms_contcase_uom = 'LB'
                            then cdt.wms_contdtl_ctwgt
                        when cdt.wms_contcase_uom = 'KG'
                            then cdt.wms_contdtl_ctwgt * 2.20462
                        else 0
                    end
            else cdt.wms_contdtl_qty * cv2.conversionvalue
        end as catchweight_lb,
        case
            when cdt.wms_contdtl_qty = 0
                then
                    case
                        when cdt.wms_contcase_uom = 'LB'
                            then cdt.wms_contdtl_ctwgt / 2.20462
                        when cdt.wms_contcase_uom = 'KG'
                            then cdt.wms_contdtl_ctwgt
                        else 0
                    end
            else cdt.wms_contdtl_qty * cv2.conversionvalue
        end as catchweight_kg,
        sum(cdt.wms_contdtl_qty) as wms_contdtl_qty,
        case
            when pmt.sf_plant_key in ('FBD', 'HERM', 'BLKS', 'NFLD')
                then 'Canada'
            when pmt.sf_plant_key in ('MACH', 'SUFF')
                then 'U.S.A.'
        end as country_of_mfg

    from {{ ref('stg_coolearth__wms_contdtl_tbl') }} as cdt

    left join {{ ref('stg_coolearth__wms_contcase_tbl') }} as cct
        on cdt.wms_conthdr_key = cct.wms_conthdr_key
            and cdt.wms_contdtl_key = cct.wms_contdtl_key
            and cdt.gl_cmp_key = cct.gl_cmp_key
            and cdt.in_whs_key = cct.in_whs_key

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

    inner join {{ ref('stg_northscope__erpx_ar_customer') }} as cus
        on soh.customersk = cus.customersk

    left join {{ ref('stg_coolearth__wms_pmint_tbl') }} as pmt
        on cdt.wms_conthdr_key = pmt.wms_conthdr_key

    inner join {{ ref('stg_northscope__erpx_so_carrier') }} as car
        on soh.carriersk = car.carriersk
            and soh.dataentitycompanysk = car.dataentitycompanysk

    inner join {{ ref('stg_northscope__erpx_ar_customer_address_attribute') }} as caa
        on soh.shipaddresssk = caa.customeraddresssk
            and soh.dataentitycompanysk = caa.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    inner join {{ ref('stg_coolearth__wms_contty_tbl') }} as ctt
        on cht.gl_cmp_key = ctt.gl_cmp_key
            and cht.wms_contty_key = ctt.wms_contty_key
            and cht.in_whs_key = ctt.in_whs_key

    where cct.wms_conthdr_key is null
        and caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue

    group by
        soh.orderid,
        cdt.in_whs_key,
        cdt.wms_conthdr_key,
        cdt.in_desc,
        cct.wms_contcase_key,
        cct.wms_contcase_prddt,
        cct.lot,
        cdt.wms_contdtl_prddt,
        cct.pieces,
        car.carriername,
        ctt.wms_contty_lay,
        ctt.wms_contty_case,
        cct.wms_contcase_ctwgt,
        cct.wms_contcase_uom,
        cdt.wms_contdtl_uom,
        iav."Category",
        cus.customername,
        cct.wms_contcase_orgwhs,
        substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)),
        cht.wms_bin_key,
        cdt.in_item_key,
        cdt.in_lot_key,
        cdt.wms_user_paramvc1,
        cdt.wms_contdtl_qty,
        pmt.sf_plant_key,
        cdt.wms_conthdr_key,
        cdt.wms_contcase_uom,
        cdt.wms_contdtl_ctwgt,
        cv2.conversionvalue
)

select

    'GM' as id_type,
    6 as pallet_type,
    pallet_layers,
    pallet_blocks,
    '' as pallet_pack,
    sum(catchweight_kg * 2.20462)::float as pallet_net_weight_lb,
    sum(catchweight_kg)::float as pallet_net_weight_kg,
    'KG' as pallet_weight_uom,
    so_number as order_id,
    cooke_item_id,
    pallet_id,
    sscc as id

from pallet_group

/* For testing */
-- where so_number like '%AFO026425%'

group by
    pallet_layers,
    pallet_blocks,
    so_number,
    sscc,
    cooke_item_id,
    pallet_id
