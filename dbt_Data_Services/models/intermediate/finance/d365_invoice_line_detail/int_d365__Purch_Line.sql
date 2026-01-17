with purch_line as (
    select * from {{ ref('stg_d365__purch_line') }}
),

purch_table as (
    select * from {{ ref('stg_d365__purch_table') }}
),

external_item as (
    select * from {{ ref('stg_d365__cust_vend_external_item') }}
),

final as (
select
    pl.itemid as "Item ID",
    pl.vendaccount as "Vendor ID",
    extitem.externalitemid as "External Item ID",
    pl.purchid as "Purchase Order",
    pt.purchname as "Vendor Name",
    pl.dataareaid as "Company",
    getdate() as lastdatarefresh,
    pl.dataareaid || pl.purchid || pl.itemid as "Company:PurchID:ItemID"
from purch_line as pl
left join external_item as extitem
    on pl.vendaccount = extitem.custvendrelation
    and pl.itemid = extitem.itemid
    and pl.dataareaid = extitem.dataareaid
left join purch_table as pt
    on pl.purchid = pt.purchid
    and pl.dataareaid = pt.dataareaid
qualify row_number() over (
    partition by pl.itemid, pl.vendaccount, extitem.externalitemid, pl.dataareaid || pl.purchid || pl.itemid
    order by pl.purchid desc
) = 1
)

select * from final
