with ce_inventory as (
    select
        'TNS' as "Company",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode,
        fct.warehouse_sk,
        item."Item_SK" as "Item ID",
        fct.in_lot_key as "Batch Number",
        fct.wms_conthdr_key as "Pallet Number",
        fct.wms_bin_key as "Location ID (Bin)",
        fct.label_date as "Label Date",
        fct.expiry_date as "Expiry Date",
        fct."Cases",
        fct.wms_contdtl_qty as "Quantity",
        fct.available_qty as "Available Quantity",
        fct."Available Cases",
        fct."Available LBs",
        fct.picked_qty as "Picked Quantity",
        fct."Picked Cases",
        fct."Picked LBs",
        fct.wms_contdtl_uom as "Unit of Measure",
        fct.wms_contdtl_ctwgtlb as "Qty LBs",
        fct.wms_contdtl_ctwgtkg as "Qty KGs",
        fct.age,
        fct.holdstatus as invent_status,
        fct."Inv Commitment Value",
        item."Form",
        md5(
            concat(
                trim("Company"),
                trim(sourcesystem),
                trim("Item ID"),
                trim("Batch Number"),
                trim("Pallet Number"),
                trim("Label Date"),
                trim(fct.warehouse_sk)
            )
        ) as fact_inventory_pk

    from {{ ref("int_global_inventory__coolearth_current") }} as fct

    left join {{ ref('dim_item') }} as item
        on fct.item_sk = item."Item_SK"
            and item.sourcesystemcode = 1

)

select * from ce_inventory
