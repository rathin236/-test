with salesperson as (
    select
        cast("Salesperson_SK" as string) "Salesperson_SK",
        cast("Salesperson ID" as string) as "Salesperson ID",
        "Salesperson Name",
        "Email",
        "Is Inactive",
        salespersontypeen,
        'D365' as sourcesystem,
        0 as sourcesystemcode
    from {{ ref('dim_salesperson_d365') }}

    union all

    select
        cast("Salesperson_SK" as string) "Salesperson_SK",
        "Salesperson ID",
        "Salesperson Name",
        "Email",
        case
            when "Is Inactive" = true then 1
            else 0
        end as "Is Inactive",
        salespersontypeen,
        'NORTHSCOPE' as sourcesystem,
        1 as sourcesystemcode
    from {{ ref('dim_salesperson_ns') }}
)

select
    *,
    md5(concat(trim("Salesperson_SK"), sourcesystem)) as sk_salesperson_global
from salesperson