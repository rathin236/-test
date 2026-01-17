with d365_mode as (
    select
        "Mode",
        'D365' as sourcesystem,
        0 as sourcesystemcode,
        row_number() over (partition by "Mode" order by "Mode") as row_num
    from {{ ref('fact_cost_d365') }}
),

ns_mode as (
    select
        "Mode",
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode,
        row_number() over (partition by "Mode" order by "Mode") as row_num
    from {{ ref('fact_cost_ns') }}
),

mode as (
    select * from d365_mode
    where row_num = 1

    union all

    select * from ns_mode
    where row_num = 1
)

select
    md5(concat("Mode", sourcesystem)) as sk_mode_global,
    "Mode",
    sourcesystem,
    sourcesystemcode
from mode
where "Mode" is not null
