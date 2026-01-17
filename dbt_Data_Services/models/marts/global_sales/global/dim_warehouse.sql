with warehouse as (
    select
        *,
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_warehouse_d365') }}

    union all

    select
        *,
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_warehouse_ns') }}
)

select
    md5(concat("Warehouse_SK", sourcesystem)) as sk_warehouse_global,
    *
from warehouse

qualify row_number() over (partition by sk_warehouse_global order by sk_warehouse_global) = 1
