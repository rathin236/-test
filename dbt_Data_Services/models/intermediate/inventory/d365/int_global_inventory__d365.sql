with invent_sum as (
    select * from {{ ref('stg_d365__invent_sum') }}
    where physicalinvent <> 0
    and inventbatchid is not null
),

invent_batch as (
    select * from {{ ref('stg_d365__invent_batch') }}
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

fact_inventory_d365 as (

    select
        'D365' as source_system,
        invent_sum.itemid,
        inb.inventbatchid as "Batch Number",
        invent_sum.licenseplateid as "Pallet Number",
        invent_sum.inventlocationid as warehouse_sk,
        invent_sum.inventsiteid as site_sk,
        invent_sum.data_lake_modified_date_time,
        inb.proddate,
        inb.expdate,
        invent_sum.availordered,
        invent_sum.availphysical,
        case
            when invent_table_module.unitid = 'CASE'
                then invent_sum.availphysical
        end as "Available Cases",
        {{ convert_to_lbs('invent_table_module.unitid', 'invent_sum.availphysical', 'lb_conv.factor') }} as "Available LBs",
        case
            when invent_table_module.unitid = 'CASE'
                then invent_sum.physicalinvent
        end as "Cases",
        invent_sum.physicalinvent as "Quantity",
        invent_sum.deducted,
        invent_sum.inventdimid,
        invent_sum.physicalinvent,
        {{ standard_unit ('invent_table_module.unitid') }} as unitid,
        {{ convert_to_lbs('invent_table_module.unitid', 'invent_sum.physicalinvent', 'lb_conv.factor') }} as inventory_volume_lbs,
        round(inventory_volume_lbs / 2.2046, 2) as inv_volume_kgs,
        datediff(day, to_date(inb.proddate), getdate()) as age,
        invent_sum.physicalvalue,
        invent_sum.picked,
        case
            when invent_table_module.unitid = 'CASE'
                then invent_sum.picked
        end as "Picked Cases",
        {{ convert_to_lbs('invent_table_module.unitid', 'invent_sum.picked', 'lb_conv.factor') }} as "Picked LBs",
        invent_sum.postedqty,
        invent_sum.postedvalue,
        invent_sum.received,
        invent_sum.registered,
        invent_sum.inventstatusid,
        invent_sum.wmslocationid as "Location ID (Bin)",
        invent_sum.dataareaid,
        invent_sum.partition,
        invent_sum._fivetran_deleted
    from invent_sum as invent_sum

    left join invent_batch as inb
        on invent_sum.inventbatchid = inb.inventbatchid
            and lower(invent_sum.itemid) = lower(inb.itemid)

    left join invent_table_module
        on invent_sum.itemid = invent_table_module.itemid
            and invent_table_module.moduletype = 0
            and invent_sum.dataareaid = invent_table_module.dataareaid

    left join unit_of_measure as uom
        on invent_table_module.unitid = uom.symbol

    left join lb_conv
        on trim(invent_sum.itemid) = trim(lb_conv.item_id)
            and trim(invent_table_module.unitid) = trim(lb_conv.fromuom)

    qualify row_number() over (partition by invent_sum.recid order by invent_sum.data_lake_modified_date_time) = 1
)

select * from fact_inventory_d365
