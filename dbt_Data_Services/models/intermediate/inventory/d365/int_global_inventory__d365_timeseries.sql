-- Timeline CTE
with invent_sum as (
    select * from {{ ref('stg_d365__invent_sum') }}
),

invent_batch as (
    select * from {{ ref('stg_d365__invent_batch') }}
),

invent_trans as (
    select * from {{ ref('stg_d365__invent_trans') }}
),

 timeline as (
    select distinct
        trans.itemid,
        invent_sum.inventlocationid,
        invent_sum.licenseplateid,
        inb.inventbatchid,
        inb.proddate,
        dates."Key_Date",
        date_trunc('week', dates."Key_Date") as "Week_Start_Date"
    from invent_trans as trans
    left join invent_sum
        on trans.inventdimid = invent_sum.inventdimid
            and trans.itemid = invent_sum.itemid
    left join invent_batch as inb
    on invent_sum.inventbatchid = inb.inventbatchid
            and invent_sum.itemid = inb.itemid
    cross join {{ ref('dim_date') }} as dates
    where dates."Key_Date" between '2022-06-01' and current_date
    order by dates."Key_Date"
),

invent_table_module as (
    select
        itemid,
        moduletype,
        dataareaid,
        {{ standard_unit ('unitid') }} as unitid
    from {{ ref('stg_d365__invent_table_module') }}
),

unit_of_measure as (
    select * from {{ ref('stg_d365__unit_of_measure') }}
),

lb_conv as (
    select
        uom_conv.product,
        prod.displayproductnumber as item_id,
        {{ standard_unit ('uom_from.symbol') }} as fromuom,
        {{ standard_unit ('uom_to.symbol') }} as touom,
        uom_conv.factor
    from {{ ref('stg_d365__unit_of_measure_conversion') }} as uom_conv

    left join {{ ref('stg_d365__unit_of_measure') }} as uom_from
        on uom_conv.fromunitofmeasure = uom_from.recid

    left join {{ ref('stg_d365__unit_of_measure') }} as uom_to
        on uom_conv.tounitofmeasure = uom_to.recid

    left join {{ ref('stg_d365__eco_res_product') }} as prod
        on uom_conv.product = prod.recid

    where uom_conv.tounitofmeasure = '5637145330'
),

-- Timeline with transactions CTE
timeline_transactions as (
    select
        timeline."Week_Start_Date",
        timeline.inventlocationid as warehouse_sk,
        timeline.inventbatchid,
        timeline.licenseplateid,
        timeline.itemid,
        timeline.proddate,
        {{ standard_unit('invent_table_module.unitid') }} as uom,
        sum(invent_trans.qty) as qty
    from timeline
        left join invent_sum
            on timeline.itemid = invent_sum.itemid
                and timeline.inventlocationid = invent_sum.inventlocationid
                    and timeline.inventbatchid = invent_sum.inventbatchid

        left join invent_trans
            on invent_sum.inventdimid = invent_trans.inventdimid
                and timeline.itemid = invent_trans.itemid
                    and timeline."Key_Date" = invent_trans.datephysical

        left join invent_table_module
            on invent_trans.itemid = invent_table_module.itemid
                and invent_table_module.moduletype = 0
                    and invent_trans.dataareaid = invent_table_module.dataareaid
    group by
        all
    order by
        timeline."Week_Start_Date"
),

-- Backfill missing values CTE
backfilled_transactions as (
    select
        "Week_Start_Date",
        itemid,
        coalesce(
            warehouse_sk, lag(warehouse_sk) over (partition by itemid, inventbatchid, licenseplateid order by "Week_Start_Date")
        ) as warehouse_sk,
        coalesce(
            inventbatchid, lag(inventbatchid) over (partition by itemid, warehouse_sk, licenseplateid order by "Week_Start_Date")
        ) as batch_number,
        sum(qty) over (partition by itemid, inventbatchid, warehouse_sk, licenseplateid order by "Week_Start_Date") as balance,
        coalesce(
            uom, lag(uom) over (partition by itemid, inventbatchid, warehouse_sk, licenseplateid order by "Week_Start_Date")
        ) as uom

    from timeline_transactions
),

-- Final CTE
final as (
    select
        md5(concat(bft."Week_Start_Date", trim(bft.itemid), trim(bft.warehouse_sk), trim(bft.batch_number))) as recid,
        bft."Week_Start_Date" as "Key_Date",
        bft.itemid,
        bft.warehouse_sk,
        bft.batch_number,
        round(bft.balance, 2) as balance,
        {{ standard_unit('invent_table_module.unitid') }} as uom,
        round({{ convert_to_lbs('invent_table_module.unitid', 'bft.balance', 'lb_conv.factor') }}, 2) as inventory_volume_lbs,
        round({{ convert_to_lbs('invent_table_module.unitid', 'bft.balance', 'lb_conv.factor') }} / 2.2046, 2) as inventory_volume_kgs,
        inb.proddate,
        case
            when to_date(inb.proddate) > bft."Week_Start_Date" then 0
        else datediff(day, to_date(inb.proddate), bft."Week_Start_Date")
    end as age

    from backfilled_transactions as bft
    left join invent_table_module
        on bft.itemid = invent_table_module.itemid
            and invent_table_module.moduletype = 0
    left join lb_conv
        on bft.itemid = lb_conv.item_id
            and upper(trim(invent_table_module.unitid)) = upper(trim(lb_conv.fromuom))
    left join invent_batch as inb
            on bft.batch_number = inb.inventbatchid
                and bft.itemid = inb.itemid
    qualify row_number() over (partition by bft.itemid, bft.warehouse_sk, bft.batch_number, "Key_Date" order by balance) = 1

)

select * from final
-- For testing
-- where itemid = 'P1004139' -- and batch_number = '3015822W' --and warehouse_sk = '1000-15' 
order by "Key_Date" desc
