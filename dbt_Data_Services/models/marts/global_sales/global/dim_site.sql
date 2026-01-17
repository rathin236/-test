with site as (
    select
        *,
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_site_d365') }}

    union all

    select
        *,
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_site_ns') }}
)

select
    md5(concat("Site_SK", sourcesystem)) as sk_site_global,
    *
from site
