with inventorylbconversion as (
    select * from {{ ref('int_global_production__inventory_lb_conversion') }}
)

select

    pct.collectrefprodid as productionbatchordernmber,
    pct.costgroupid,
    pct.idreftableid,
    pct.production,
    cost_group.name as transactiontype,
    pct.resource as transactionitem,
    erpt.name as "item description",
    pct.unitid,
    pct.realconsump,
    pct.realcostadjustment,
    pct.realcostamount,
    pct.consumpvariable,
    pct.realqty,
    pct.costamount,
    pct.calctype,
    iigi.itemgroupid,
    pct.qty,
    'byprod' as "original table",
    case
        when pct.unitid = 'lb' then pct.realconsump
        when pct.unitid != 'lb' then pct.realconsump * inventorylbconversion.factor
        else 0
    end as "quantity (lb)",
    case
        when pct.unitid = 'lb' then pct.consumpvariable
        when pct.unitid != 'lb' then pct.consumpvariable * inventorylbconversion.factor
        else 0
    end as "consumpvariable (lb)",
    case
        when pct.unitid = 'lb' then pct.realqty
        when pct.unitid != 'lb' then pct.realqty * inventorylbconversion.factor
        else 0
    end as "real quantity (lb)",
    case
        when pct.unitid = 'lb' then pct.qty
        when pct.unitid != 'lb' then pct.qty * inventorylbconversion.factor
        else 0
    end as "qty (lb)"

from {{ ref('stg_d365__pmf_co_by_prod_calc_trans') }} as pct

left join {{ ref('stg_d365__bomcost_group') }} as cost_group
    on pct.costgroupid = cost_group.costgroupid

left join inventorylbconversion
    on pct.resource = inventorylbconversion.itemid
        and pct.unitid = inventorylbconversion.fromuom

left join {{ ref('stg_d365__eco_res_product') }} as prod
    on pct.resource = prod.displayproductnumber

left join {{ ref('stg_d365__eco_res_product_translation') }} as erpt
    on prod.recid = erpt.product
        and erpt.languageid = 'en-US'

left join {{ ref('stg_d365__invent_item_group_item') }} as iigi
    on pct.resource = iigi.itemid
