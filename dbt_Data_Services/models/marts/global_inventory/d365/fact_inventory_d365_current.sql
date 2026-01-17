with d365_inventory as (
    select
        'TNSF' as "Company",
        fct.source_system as sourcesystem,
        0 as sourcesystemcode,
        fct.warehouse_sk,
        item."Item ID",
        fct."Batch Number",
        fct."Pallet Number",
        fct."Location ID (Bin)",
        fct.proddate as "Label Date",
        fct.expdate as "Expiry Date",
        fct."Cases",
        fct."Quantity",
        fct.availphysical as "Available Quantity",
        fct."Available Cases",
        fct."Available LBs",
        fct.picked as "Picked Quantity",
        fct."Picked Cases",
        fct."Picked LBs",
        fct.unitid as "Unit of Measure",
        fct.inventory_volume_lbs as "Qty LBs",
        fct.inv_volume_kgs as "Qty KGs",
        fct.age,
        fct.inventstatusid as invent_status,
        item."Form",
        md5(
            concat(
                trim("Company"),
                trim(sourcesystem),
                trim(fct.warehouse_sk),
                trim(item."Item ID"),
                trim(fct."Batch Number"),
                trim(fct."Location ID (Bin)"),
                trim(fct.proddate),
                trim(fct.inventstatusid)
            )
        ) as fact_inventory_pk

    from
        {{ ref('int_global_inventory__d365') }} as fct

    inner join {{ ref('dim_item') }} as item
        on fct.itemid = item."Item ID"
            and item.sourcesystemcode = 0
)

select * from d365_inventory
-- for testing
-- where "Item ID" = 'P1004314'
