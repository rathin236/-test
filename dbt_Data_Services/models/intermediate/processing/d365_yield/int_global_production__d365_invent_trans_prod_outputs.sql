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

enum_3415 as (
    select
        enumvaluelabel,
        enumvalue
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 3415
)

select
    ito.referencecategory,
    inventorylbconversion.factor,
    inv_tran.statusreceipt,
    enum_3415.enumvaluelabel as "receipt status",
    concat(ito.referenceid, inv_tran.itemid) as "pbo item",
    case
        when itm.unitid = 'lb'
            then sum(inv_tran.qty) over (partition by ito.referenceid, inv_tran.itemid)
        when itm.unitid != 'lb'
            then sum(inv_tran.qty * inventorylbconversion.factor) over (partition by ito.referenceid, inv_tran.itemid)
        else 0
    end as "quantity (lb)",
    row_number() over (
        partition by concat(ito.referenceid, inv_tran.itemid)
        order by concat(ito.referenceid, inv_tran.itemid)
    ) as dedupe

from {{ ref('stg_d365__invent_trans') }} as inv_tran

left join {{ ref('stg_d365__invent_trans_origin') }} as ito
    on inv_tran.inventtransorigin = ito.recid

left join itm
    on inv_tran.itemid = itm.itemid

left join inventorylbconversion
    on inv_tran.itemid = inventorylbconversion.itemid
        and itm.unitid = inventorylbconversion.fromuom

inner join enum_3415
    on inv_tran.statusreceipt = enum_3415.enumvalue

where (ito.referencecategory = 2 or ito.referencecategory = 100)
    and (inv_tran.statusreceipt != 5)
