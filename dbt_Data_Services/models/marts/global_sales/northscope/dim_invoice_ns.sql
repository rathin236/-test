with order_header as (
    select * from {{ ref('stg_northscope__erpx_so_order_header') }}
),

dim_invoice as (
    select orderid as "Invoice ID" from order_header

    qualify row_number() over (partition by orderid order by orderid) = 1

    order by orderid
)

select * from dim_invoice
