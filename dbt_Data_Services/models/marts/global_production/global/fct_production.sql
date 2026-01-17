with d365 as (
    select
        fct."date_productionbatchorder",
        fct."pbo header",
        fct."production pool id",
        fct."production status id",
        fct."status",
        whouse.sk_warehouse_global,
        site.sk_site_global,
        fct."batchid",
        fct.bomid,
        fct."inventory unit id",
        fct."pbo line",
        fct.costgroupid,
        fct.idreftableid,
        fct.production,
        fct."transaction type",
        fct."transaction item",
        fct."uom",
        fct."quantity (lb)",
        fct."real consumption",
        fct."real cost adjustment",
        fct."real cost amount",
        fct."consumption variable (lb)",
        fct."consumption variable",
        fct."real quantity (lb)",
        fct."real qty",
        fct."cost amount",
        fct."calc type",
        fct.qty,
        fct."qty (lb)",
        fct."original table",
        fct."pboitem header",
        fct."last data refresh",
        fct."item id",
        item.sk_item_global,
        fct.conversionfactor,
        fct."pboitem line",
        fct."production inventory output qty (lbs)",
        0 as sourcesystemcode

    from {{ ref('fct_production_d365') }} as fct

    left join {{ ref('dim_item') }} as item
        on fct."item id" = item."Item ID"
            and item.sourcesystemcode = 0

    left join {{ ref('dim_warehouse') }} as whouse
        on fct."warehouse_id" = whouse."Location ID"
            and item.sourcesystemcode = 0

    left join {{ ref('dim_site') }} as site
        on fct."site_id" = site."Site ID"
            and site.sourcesystemcode = 0
)

select
    fct."date_productionbatchorder",
    fct."pbo header",
    fct."production pool id",
    fct."production status id",
    fct."status",
    fct.sk_warehouse_global,
    fct.sk_site_global,
    fct."batchid",
    fct.bomid,
    fct."inventory unit id",
    fct."pbo line",
    fct.costgroupid,
    fct.idreftableid,
    fct.production,
    fct."transaction type",
    fct."transaction item",
    fct."uom",
    fct."quantity (lb)",
    fct."real consumption",
    fct."real cost adjustment",
    fct."real cost amount",
    fct."consumption variable (lb)",
    fct."consumption variable",
    fct."real quantity (lb)",
    fct."real qty",
    fct."cost amount",
    fct."calc type",
    fct.qty,
    fct."qty (lb)",
    fct."original table",
    fct."pboitem header",
    fct."last data refresh",
    fct."item id",
    fct.sk_item_global,
    fct.conversionfactor,
    fct."pboitem line",
    fct."production inventory output qty (lbs)",
    fct.sourcesystemcode,
    to_number(to_char(fct."date_productionbatchorder", 'YYYYMMDD')) as "Date Key"

from d365 as fct
