with coolearth_data as (
    -- Catchweight items
    select

        cdt.in_lot_key as serial_lot_number,
        cdt.wms_contdtl_prddt as production_date,
        cdt.wms_contdtl_puldt as expiry_date,
        trim(cdt.in_item_key) as item_id,
        sum(1) as qty_shipped,
        sum(case
            when cdt.wms_contdtl_qty = 0
                then
                    case
                        when cdt.wms_contcase_uom = 'LB' then cdt.wms_contdtl_ctwgt / 2.20462
                        when cdt.wms_contcase_uom = 'KG' then cdt.wms_contdtl_ctwgt
                        else cdt.wms_contdtl_ctwgt
                    end
            else (case
                when cct.wms_contcase_uom = 'LB' then cct.wms_contcase_ctwgt / 2.20462
                when cct.wms_contcase_uom = 'KG' then cct.wms_contcase_ctwgt
                else cct.wms_contcase_ctwgt
            end)
        end) as gross_weight_pp,
        'KG' as gross_weight_pp_uom,
        soh.orderid as so_number,
        cdt.wms_conthdr_key

    from {{ ref('stg_coolearth_sb1__wms_contcase_tbl') }} as cct

    left join {{ ref('stg_coolearth_sb1__wms_contdtl_tbl') }} as cdt
        on cct.wms_conthdr_key = cdt.wms_conthdr_key
            and cct.wms_contdtl_key = cdt.wms_contdtl_key
            and cct.gl_cmp_key = cdt.gl_cmp_key
            and cct.in_whs_key = cdt.in_whs_key

    inner join {{ ref('item_attribute_values_sb1') }} as iav
        on cdt.in_item_key = iav.item_id
            and iav.dataentitycompany_sk = 1

    inner join {{ ref('stg_northscope_sb1__erpx_so_order_header') }} as soh
        on substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) = soh.orderid

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address_attribute') }} as caa
        on soh.shipaddresssk = caa.customeraddresssk
            and soh.dataentitycompanysk = caa.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue -- noqa: disable=PRS

    group by all
    -- noqa: enable=PRS

    union all

    -- Fixed weight or weight only items
    select

        cdt.in_lot_key as serial_lot_number,
        cdt.wms_contdtl_prddt as production_date,
        cdt.wms_contdtl_puldt as expiry_date,
        trim(cdt.in_item_key) as item_id,
        sum(case
            when cdt.wms_contdtl_qty = 0 then 0
            else (case
                when cdt.wms_contdtl_uom = 'LB' then cdt.wms_contdtl_qty / 2.20462
                when cdt.wms_contdtl_uom = 'KG' then cdt.wms_contdtl_qty
                else cdt.wms_contdtl_qty
            end)
        end) as qty_shipped,
        sum(case
            when cdt.wms_contdtl_qty = 0
                then
                    case
                        when cdt.wms_contcase_uom = 'LB'
                            then cdt.wms_contdtl_ctwgt / 2.20462
                        when cdt.wms_contcase_uom = 'KG'
                            then cdt.wms_contdtl_ctwgt
                        else cdt.wms_contdtl_ctwgt
                    end
            else cdt.wms_contdtl_qty * cv2.conversionvalue
        end) as gross_weight_pp,
        'KG' as gross_weight_pp_uom,
        soh.orderid as so_number,
        cdt.wms_conthdr_key

    from {{ ref('stg_coolearth_sb1__wms_contdtl_tbl') }} as cdt

    left join {{ ref('stg_coolearth_sb1__wms_contcase_tbl') }} as cct
        on cdt.wms_conthdr_key = cct.wms_conthdr_key
            and cdt.wms_contdtl_key = cct.wms_contdtl_key
            and cdt.gl_cmp_key = cct.gl_cmp_key
            and cdt.in_whs_key = cct.in_whs_key

    inner join {{ ref('item_attribute_values_sb1') }} as iav
        on cdt.in_item_key = iav.item_id
            and iav.dataentitycompany_sk = 1

    inner join {{ ref('stg_northscope_sb1__erpx_so_order_header') }} as soh
        on substring(cdt.wms_contdtl_alloc, charindex('_', cdt.wms_contdtl_alloc) + 1, len(cdt.wms_contdtl_alloc)) = soh.orderid

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address_attribute') }} as caa
        on soh.shipaddresssk = caa.customeraddresssk
            and soh.dataentitycompanysk = caa.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    inner join {{ ref('stg_northscope_sb1__erpx_so_order_item') }} as soi
        on soh.dataentitycompanysk = soi.dataentitycompanysk
            and soh.orderheadersk = soi.orderheadersk

    inner join {{ ref('stg_northscope_sb1__erpx_im_item') }} as item
        on soh.dataentitycompanysk = item.dataentitycompanysk
            and cdt.in_item_key = item.itemid
            and soi.itemsk = item.itemsk

    left join {{ ref('stg_northscope_sb1__erpx_im_uom_schedule_conversion_value') }} as cv2
        on item.uomschedulesk = cv2.uomschedulesk
            and soi.unitsuomsk = cv2.fromuomsk
            and cv2.touomsk = '{{ var("edi_856_item_uom") }}'
            and item.dataentitycompanysk = cv2.dataentitycompanysk

    /* This part is important, and ultimately what filters the data we are pulling! MP 2023-06-13 */
    where cct.wms_conthdr_key is null
        and caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue -- noqa: disable=PRS

    group by all
    -- noqa: enable=PRS
)

select * from coolearth_data

/* For testing */
-- where so_number like '%AFO026562%'
