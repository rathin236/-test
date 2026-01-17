with so_order_item as (
    select * from {{ ref('stg_northscope__erpx_so_order_item') }}
),

so_order_header as (
    select * from {{ ref('stg_northscope__erpx_so_order_header') }}
),

im_item as (
    select * from {{ ref('stg_northscope__erpx_im_item') }}
),

uom_schedule_conversion_value as (
    select *
    from {{ ref('stg_northscope__erpx_im_uom_schedule_conversion_value') }}
),

uom as (
    select * from {{ ref('int_global_sales__ns_uom') }}
),

rebates as (
    select * from {{ ref('int_global_sales__fact_rebates_northscope') }}
),

ub_market_data as (
    select * from {{ ref('int_global_sales__urnerbarry_items') }}
),

fact_order_item as (
    select
        soi.orderitemsk,
        soh.orderid,
        rebates.rebate_currency,
        soi.dataentitycompanysk,
        soi.orderheadersk,
        soi.itemsk,
        imi.itemid,
        soi.orderedunits,
        soi.allocatedunits,
        soi.imitemactualcost,
        soi.orderitemactualcost,
        soi.itemprice,
        imi.currentcost,
        soi.orderedamount,
        soi.allocatedamount,
        soi.invoicedamount,
        ub_data.ub_price_high,
        ub_data.ub_price_avg,
        ub_data.ub_price_low,
        soi.sitesk,
        soi.lastuser,
        soi.lastupdated,
        cast(soi.createddate as date) as created_date,
        soi.unitsuomsk,
        imi.uomschedulesk,
        rebates.rebate_amount,
        uom.so_weight_uom as so_wt_uom,
        uom.price_uom,
        (soi.imitemactualcost * soi.allocatedweight) as settled_cost,
        coalesce(uom.unit_uom, 'units') as uom_id,
        coalesce(
            (soi.orderedweight * cv1.conversionvalue),
            (soi.orderedweight * cv1a.conversionvalue)
        ) as ordered_lbs,
        soi.orderedweight * cv2.conversionvalue as ordered_kg,
        coalesce(
            (soi.allocatedweight * cv1.conversionvalue),
            (soi.allocatedweight * cv1a.conversionvalue)
        ) as allocated_lbs,
        soi.allocatedweight * cv2.conversionvalue as allocated_kg

    from so_order_item as soi

    inner join so_order_header as soh
        on
            soi.orderheadersk = soh.orderheadersk
            and soi.dataentitycompanysk = soh.dataentitycompanysk

    inner join im_item as imi
        on soi.itemsk = imi.itemsk

    left join rebates
        on trim(soh.orderid) = rebates.orderid
            and imi.itemid = rebates.item_id
                and soi.orderitemsk = rebates.orderitemsk

    left join uom_schedule_conversion_value as cv1
        on
            imi.uomschedulesk = cv1.uomschedulesk
            and soi.weightuomsk = cv1.fromuomsk
            and lower(cv1.touomid) = 'lb'
            and soi.dataentitycompanysk != 5

    left join uom_schedule_conversion_value as cv1a
        on
            imi.uomschedulesk = cv1a.uomschedulesk
            and soi.weightuomsk = cv1a.fromuomsk
            and lower(cv1a.touomid) = 'lbs'
            and soi.dataentitycompanysk = 5

    left join uom_schedule_conversion_value as cv2
        on
            imi.uomschedulesk = cv2.uomschedulesk
            and soi.weightuomsk = cv2.fromuomsk
            and lower(cv2.touomid) = 'kg'

    left join uom
        on soi.itemsk = uom.item_sk
            and imi.itemid = uom.item_id

    left join ub_market_data as ub_data
        on trim(soi.itemsk) = trim(ub_data.item_sk)
            and cast(soi.createddate as date) between ub_data.previous_quote_date and ub_data.quote_date

)

select * from fact_order_item

/* For Testing */
-- where orderid = 'R-TNS316154A'
