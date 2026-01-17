with sourcesystem as (
    select
        0 as sk_sourcesystem_global,
        'D365' as sourcesystem

    union all

    select
        1 as sk_sourcesystem_global,
        'NORTHSCOPE' as sourcesystem
)

select * from sourcesystem
