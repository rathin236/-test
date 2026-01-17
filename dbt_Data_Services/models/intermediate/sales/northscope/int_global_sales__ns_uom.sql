with im_item as (
   select * from {{ ref('stg_northscope__erpx_im_item') }}
),

unit_uom as (
   select * from {{ ref('stg_northscope__erpx_im_uom') }}
),

wt_uom as (
   select * from {{ ref('stg_northscope__erpx_im_uom') }}
),

price_uom as (
   select * from {{ ref('stg_northscope__erpx_im_uom') }}
),

 final as (

    select
        it.itemsk as item_sk,
        it.hostsystemlink,
        it.itemid as item_id,
        it.itemdescription,
        itemtypesk as item_type_sk,
        it.uomschedulesk,
        trim(upper(coalesce(unit_uom.uomname, unit_uom.hostsystemlink, 'units'))) as unit_uom,
        trim(upper(wt_uom.uomname)) as so_weight_uom,
        trim(upper(price_uom.uomname)) as price_uom

    from im_item as it

    left join unit_uom
        on it.defaultimunituomsk = unit_uom.uomsk
        and it.dataentitycompanysk = unit_uom.dataentitycompanysk

    left join wt_uom
        on it.defaultsoweightuomsk = wt_uom.uomsk
            and it.dataentitycompanysk = wt_uom.dataentitycompanysk

    left join price_uom
        on it.defaultsopriceuomsk = price_uom.uomsk
            and it.dataentitycompanysk = price_uom.dataentitycompanysk
)

select * from final
/* for testing */
-- where 
-- item_id = '10010' and 
-- item_sk = '6144'
