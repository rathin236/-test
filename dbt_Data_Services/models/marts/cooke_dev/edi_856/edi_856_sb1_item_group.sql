with coolearth_data as (
    select * from {{ ref('int_edi_856_sb1__coolearth_cw_and_pallet_quantities') }}
),

ce_group as (
    select

        soi.itemprice as unit_price,
        'KG' as gross_weight_pp_uom,
        soh.orderid as order_id,
        item.uomschedulesk,
        soi.weightuomsk,
        ced.wms_conthdr_key as pallet_id,
        ced.item_id as cooke_item_id,
        iff(item.manageitemsbyen = 2, cv2.touomid, cv1.touomid) as uom,
        ced.serial_lot_number,
        iff(soi.allocatedunits = 0, soi.allocatedweight, coalesce(ced.qty_shipped, soi.allocatedunits)) as number_of_cases,
        sum(ced.gross_weight_pp) as gross_weight_kg,
        sum(ced.gross_weight_pp) * 2.20462 as gross_weight_lb,
        coalesce(item.upc, 'None') as case_code,
        coalesce(item.upc, 'None') as upc_code,
        case
            when soi.orderedunits = 0
                then soi.orderedweight
            else coalesce(soi.orderedunits, soi.allocatedunits)
        end as qty_ordered,
        case
            when soi.allocatedunits = 0
                then soi.allocatedweight
            else coalesce(ced.qty_shipped, soi.allocatedunits)
        end as qty_shipped,
        case
	        when item.manageitemsbyen = '2' and item.isitemvariableweight = '1' then '1' --Weight Only
            when item.manageitemsbyen = '3' and item.isitemvariableweight = '1' then '1' --Variable Weight
            when item.manageitemsbyen = '1' and item.isitemvariableweight = '0' then '0' --Fixed Weight
            when item.manageitemsbyen = '3' and item.isitemvariableweight = '0' then '0' --Fixed Weight
            when item.manageitemsbyen = '1' and item.isitemvariableweight = '0' then '0' --Fixed Weight
            when item.manageitemsbyen = '2' and item.isitemvariableweight = '0' then '1' --Weight Only
            else '0' --Incorrect
        end as is_catch_wgt,
        case
            when soi.priceoptionsk='2' then trim(uomw.uomid)
            else trim(uom.uomid)
        end as unit_price_uom,
        coalesce(
            sub1.customeritemid,
            fav.customeritemid,
            sub2.customeritemid,
            fav2.customeritemid,
            favs.customeritemid,
            fav2s.customeritemid,
            item.itemid,
            ''
        ) as item_number,
        coalesce(
            sub1.customeritemdescription,
            fav.customeritemdescription,
            sub2.customeritemdescription,
            fav2.customeritemdescription,
            favs.customeritemdescription,
            fav2s.customeritemdescription,
            item.itemdescription,
            ''
        ) as item_description,
        coalesce(soi.originorderitemsk, soi.orderitemsk) as po_line_id,
        to_date(ced.production_date) as production_date,
        to_date(ced.expiry_date) as expiry_date

    from {{ ref('stg_northscope_sb1__erpx_so_order_item') }} as soi

    inner join {{ ref('stg_northscope_sb1__erpx_so_order_header') }} as soh
        on soi.orderheadersk = soh.orderheadersk
            and soi.dataentitycompanysk = soh.dataentitycompanysk

    inner join {{ ref('stg_northscope_sb1__erpx_im_item') }} as item
        on soi.itemsk = item.itemsk

    left join {{ ref('stg_northscope_sb1__erpx_im_uom_schedule_conversion_value') }} as cv1
        on cv1.uomschedulesk = item.uomschedulesk
            and cv1.fromuomsk = soi.unitsuomsk
            and cv1.touomsk = '{{ var("edi_856_unit_uom") }}'
            and cv1.dataentitycompanysk = item.dataentitycompanysk

    left join {{ ref('stg_northscope_sb1__erpx_im_uom_schedule_conversion_value') }} as cv2
        on cv2.uomschedulesk = item.uomschedulesk
            and cv2.fromuomsk = soi.unitsuomsk
            and cv2.touomsk = '{{ var("edi_856_item_uom") }}' --kg
            and cv2.dataentitycompanysk = item.dataentitycompanysk

    inner join {{ ref('item_attribute_values_sb1') }} as iav
        on soi.itemsk = iav.item_sk

    inner join {{ ref('stg_northscope_sb1__erpx_im_uom') }} as uom
        on soi.unitsuomsk = uom.uomsk
            and soi.dataentitycompanysk = uom.dataentitycompanysk

    inner join {{ ref('stg_northscope_sb1__erpx_im_uom') }} as uomw
        on soi.weightuomsk = uomw.uomsk
            and soi.dataentitycompanysk = uomw.dataentitycompanysk

    inner join {{ ref('stg_northscope_sb1__erpx_ar_customer_address_attribute') }} as caa
        on caa.customeraddresssk = soh.shipaddresssk
            and caa.dataentitycompanysk = soh.dataentitycompanysk
            and caa.attributesk = '{{ var("edi_856_go_live_attribute") }}'

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_favorite') }} as fav
        on fav.itemsk = soi.itemsk
            and fav.customerentitysk = soh.shipaddresssk
            and fav.customerfavoritetypesk = 2 -- Address Join

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_favorite') }} as fav2
        on fav.itemsk = soi.itemsk
            and fav.customerentitysk = soh.shipaddresssk
            and fav.customerfavoritetypesk = 1 -- Customer Join

    left join {{ ref('stg_northscope_sb1__erpx_so_order_item') }} as oi2
        on oi2.orderitemsk = soi.originorderitemsk
            and soi.originitemtypeen = 3

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_substitute_item') }} as sub1
        on sub1.customerfavoritesk = fav.customerfavoritesk
            and sub1.substituteitemsk = oi2.itemsk

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_substitute_item') }} as sub2
        on sub2.customerfavoritesk = fav2.customerfavoritesk
            and sub1.substituteitemsk = oi2.itemsk

    left join coolearth_data as ced
        on soh.orderid = ced.so_number
            and iav.item_id = ced.item_id

    left join {{ ref('stg_northscope_sb1__erpx_so_order_item') }} as sois
        on soi.dataentitycompanysk = sois.dataentitycompanysk
            and soi.originorderitemsk = sois.orderitemsk

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_favorite') }} as favs
        on favs.itemsk = sois.itemsk
            and favs.customerentitysk = soh.shipaddresssk
            and favs.customerfavoritetypesk = 2 -- Address Join

    left join {{ ref('stg_northscope_sb1__erpx_ar_customer_favorite') }} as fav2s
        on fav2s.itemsk = sois.itemsk
            and fav2s.customerentitysk = soh.shipaddresssk
            and fav2s.customerfavoritetypesk = 1 -- Customer Join

    where caa.attributevalue < current_date()
        and caa.attributevalue > '{{ var("edi_856_attribute_date") }}'
        and soh.createddate > caa.attributevalue -- noqa: disable=PRS

    group by all
    -- noqa: enable=PRS

),

item_group as (
    select
        unit_price,
        gross_weight_pp_uom,
        order_id,
        uomschedulesk,
        weightuomsk,
        pallet_id,
        cooke_item_id,
        uom,
        serial_lot_number,
        case
            when unit_price_uom = 'lb' then round(unit_price * round(gross_weight_lb,2),2)
            when unit_price_uom = 'kg' then round(unit_price * round(gross_weight_kg,2),2)
            else round(unit_price * qty_shipped,2)
        end as net_unit_price,
        case
            when unit_price_uom = 'lb' then round(unit_price * round(gross_weight_lb,2),2)
            when unit_price_uom = 'kg' then round(unit_price * round(gross_weight_kg,2),2)
            else round(unit_price * qty_shipped,2)
        end as extended_net_price,
        number_of_cases,
        gross_weight_kg,
        gross_weight_lb,
        case_code,
        upc_code,
        qty_ordered,
        qty_shipped,
        is_catch_wgt,
        unit_price_uom,
        item_number,
        item_description,
        po_line_id,
        production_date,
        expiry_date
    from ce_group

    group by all
    -- noqa: enable=PRS

)

select * from item_group

/* For Testing */
-- where order_id = 'TNS122272'
