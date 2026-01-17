with d365_inventory as (
    select
        'TNSF' as "Company",
        'D365' as sourcesystem,
        0 as sourcesystemcode,
        fct."Key_Date",
        fct.warehouse_sk,
        fct.batch_number as "Batch Number",
        '' as "Pallet Number",
        item."Item ID",
        fct.uom as "Unit of Measure",
        fct.balance as "Balance Qty",
        case
            when fct.uom = 'CASE'
                then fct.balance
        end as "Cases",
        fct.inventory_volume_lbs as "Balance LBs",
        fct.inventory_volume_kgs as "Balance KGs",
        fct.age as Age,
        fct.proddate as "Production Date"
    from
        {{ ref("int_global_inventory__d365_timeseries") }} as fct

    left join {{ ref('dim_item') }} as item
        on fct.itemid = item."Item ID"
            and item.sourcesystemcode = 0
)

select distinct * from d365_inventory
-- where "Item ID" = 'P1003134'
-- and warehouse_sk = '1000-15' and "Batch Number" = '224380'
order by "Key_Date" desc
