with d365_uom as (
    select
        'D365' as sourcesystem,
        0 as sourcesystemcode,
        upper("Sales Unit") as uom,
        row_number() over (partition by upper("Sales Unit") order by upper("Sales Unit"))
            as row_number
    from {{ ref('fact_cost_d365') }}
),

ns_uom as (
    select
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode,
        upper(trim("Sales UOM")) as uom,
        row_number() over (partition by upper(trim("Sales UOM")) order by upper("Sales UOM"))
            as row_number
    from {{ ref('fact_cost_ns') }}
),

uom as (
    select * from d365_uom
    where row_number = 1

    union all

    select * from ns_uom
    where row_number = 1
)

select
    uom,
    sourcesystem,
    sourcesystemcode,
    md5(concat(coalesce(nullif(trim(uom), ''), 'UNKNOWN'), sourcesystem)) as sk_uom_global
from uom
