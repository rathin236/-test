with order_status as (
    select
        *,
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_order_status_d365') }}

    union all

    select
        *,
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_order_status_ns') }}
)

select
    md5(concat(cast("Order Status ID" as int), sourcesystem)) as sk_order_status_id_global,
    *
from order_status
