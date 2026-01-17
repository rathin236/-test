with order_id as (
    select
        *,
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_orders_d365') }}

    union all

    select
        *,
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_orders_ns') }}
),

order_id_data as (
    select
        *,
        row_number() over (partition by "Order ID" order by sourcesystem desc) as row_num,
        md5(concat(coalesce("Order ID", ''), sourcesystem)) as sk_order_id_global
    from order_id
)

select * from order_id_data
where row_num = 1
