with sales_table_northscope as (
    select * from {{ ref('stg_northscope__erpx_so_order_header') }}
),

dim_orders as (
    select orderid as "Order ID" from sales_table_northscope

    qualify row_number() over (partition by orderid order by orderid) = 1

    order by orderid
)

select * from dim_orders
