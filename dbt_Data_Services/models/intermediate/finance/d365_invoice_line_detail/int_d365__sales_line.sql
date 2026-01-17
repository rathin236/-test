with sales_line as (
    select
        inventrefid,
        inventtransid,
        itemid,
        salesqty,
        salesunit,
        dataareaid,
        salesid,
        linenum,
        partition,
        deliverytype
    from {{ ref('stg_d365__sales_line') }}
),

enum as (
    select
        enumvaluelabel,
        enumvalue
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 5431
),

final as (
    select
        enum.enumvaluelabel as "Delivery Type",
        sl.inventtransid,
        sl.itemid as "Item ID",
        sl.salesqty as "Quantity",
        sl.salesunit as "Unit",
        sl.dataareaid as "Company",
        sl.salesid as "Sales Order",
        sl.linenum,
        sl.partition,
        trim(sl.inventrefid) as "Reference Number",
        sl.dataareaid || sl.salesid || sl.itemid as "Company:SalesID:ItemID",
        dataareaid || coalesce(sl.inventrefid, '') || sl.itemid as "Company:RefID:ItemID",
        dataareaid || sl.inventtransid || sl.partition as "Packing Slip Key"
    from sales_line as sl
    inner join enum on sl.deliverytype = enum.enumvalue
)

select * from final
