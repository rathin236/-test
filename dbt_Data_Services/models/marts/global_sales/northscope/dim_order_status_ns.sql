with so_order_status as (
    select * from {{ ref('stg_northscope__erpx_so_order_status') }}
),

dim_order_status as (
    select

        orderstatussk as "Order Status ID",
        orderstatusname as "Order Status"

    from so_order_status

    qualify row_number() over (partition by orderstatussk order by orderstatussk) = 1

    order by orderstatussk
)

select * from dim_order_status
