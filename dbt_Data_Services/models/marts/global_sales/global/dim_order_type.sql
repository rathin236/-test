with order_type as (
    select
        "Order Type ID",
        "Order Type",
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_order_type_d365') }}

    union all

    select
        "Order_Type_SK",
        case
            when "Order Type Name" = 'Order' then 'Sales order'
            when "Order Type Name" = 'Return order' then 'Returned order'
            when "Order Type Name" = 'Quote' then 'Quotation'
            else "Order Type Name"
        end as "Order Type Name",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_order_type_ns') }}

)

select
    md5(concat(cast("Order Type ID" as int), sourcesystem)) as sk_order_type_id_global,
    *
from order_type
