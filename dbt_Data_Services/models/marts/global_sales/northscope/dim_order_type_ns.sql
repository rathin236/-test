with so_order_type as (
    select * from {{ ref('stg_northscope__erpx_so_order_type') }}
),

dim_order_type as (
    select

        ordertypesk as "Order_Type_SK",
        iff(ordertypename = 'Return', 'Return order', ordertypename) as "Order Type Name"

    from so_order_type
)

select * from dim_order_type
