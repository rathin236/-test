with inventorylbconversion as (
    select * from {{ ref('int_global_production__inventory_lb_conversion') }}
),

itm as (
    select
        itemid,
        unitid
    from {{ ref('stg_d365__invent_table_module') }}
    where moduletype = 2
),

enum_1945 as (
    select
        enumvaluelabel,
        enumvalue
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 1945
),

batch_details as (

    select * from {{ ref('int_global_production__d365_prod_calc_trans') }}

    union all

    select * from {{ ref('int_global_production__d365_by_prod') }}

),

inventtransprodoutputs as (
    select * from {{ ref('int_global_production__d365_invent_trans_prod_outputs') }}
)

select

    prod_t.dlvdate as "date_productionbatchorder",
    prod_t.prodid as "pbo header",
    prod_t.prodpoolid as "production pool id",
    prod_t.prodstatus as "production status id",
    enum_1945.enumvaluelabel as "status",
    inv_dim.inventlocationid as "warehouse_id",
    inv_dim.inventbatchid as "batchid",
    prod_t.bomid,
    itm.unitid as "inventory unit id",
    batch_d.productionbatchordernmber as "pbo line",
    batch_d.costgroupid,
    batch_d.idreftableid,
    batch_d.production,
    batch_d.transactiontype as "transaction type",
    batch_d.transactionitem as "transaction item",
    batch_d.unitid as "uom",
    batch_d."quantity (lb)",
    batch_d.realconsump as "real consumption",
    batch_d.realcostadjustment as "real cost adjustment",
    batch_d.realcostamount as "real cost amount",
    batch_d."consumpvariable (lb)" as "consumption variable (lb)",
    batch_d.consumpvariable as "consumption variable",
    batch_d."real quantity (lb)",
    batch_d.realqty as "real qty",
    batch_d.costamount as "cost amount",
    batch_d.calctype as "calc type",
    batch_d.qty,
    batch_d."qty (lb)",
    batch_d."original table",
    replace(split(inv_dim.inventlocationid, '-')[0], '"', '') as "site_id",
    concat(prod_t.prodid, prod_t.itemid) as "pboitem header",
    getdate() as "last data refresh",
    trim(prod_t.itemid) as "item id",
    case
        when itm.unitid = 'lb' then 1
        else inventorylbconversion.factor
    end as conversionfactor,
    concat(batch_d.productionbatchordernmber, batch_d.transactionitem) as "pboitem line",

    case
        when itpo.referencecategory in (2, 100)
            then itpo."quantity (lb)"
        else 0
    end as "production inventory output qty (lbs)"

from batch_details as batch_d

full outer join {{ ref('stg_d365__prod_table') }} as prod_t
    on batch_d.productionbatchordernmber = prod_t.prodid

full outer join {{ ref('stg_d365__invent_dim') }} as inv_dim
    on prod_t.inventdimid = inv_dim.inventdimid

full outer join inventtransprodoutputs as itpo
    on concat(batch_d.productionbatchordernmber, batch_d.transactionitem) = itpo."pbo item"

inner join enum_1945
    on prod_t.prodstatus = enum_1945.enumvalue

left join itm
    on prod_t.itemid = itm.itemid

left join inventorylbconversion
    on prod_t.itemid = inventorylbconversion.itemid
        and itm.unitid = inventorylbconversion.fromuom

where itpo.dedupe = 1
