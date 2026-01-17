with fact_inventory as (
-- noqa: disable=PRS
    {{ dbt_utils.union_relations(

    relations=[ref('fact_inventory_d365_timeline'),
                ref('fact_inventory_timeline_coolearth')
    ]
) }}
-- noqa: disable=PRS
),

sk_global as (
    select
        "Company",
        sourcesystem,
        sourcesystemcode,
        "Key_Date",
        warehouse_sk as "Warehouse",
        "Batch Number",
        "Pallet Number",
        "Item ID",
        "Unit of Measure",
        "Balance Qty",
        "Cases",
        {{ standard_unit ('"Unit of Measure"') }} as "Standard Unit",
        "Balance LBs",
        "Balance KGs",
        Age,
        "Production Date",
        md5(concat(trim("Item ID"), sourcesystem)) as sk_item_global,
        md5(concat(warehouse_sk, sourcesystem)) as sk_warehouse_global
    -- md5(concat(site_sk, sourcesystem)) as sk_site_global (for future use)

    from fact_inventory
)

select * from sk_global --where "Pallet Number" = '12275737' and "Batch Number" = '26097WC' order by "Key_Date" desc
-- where "Key_Date" = '2024-08-19'