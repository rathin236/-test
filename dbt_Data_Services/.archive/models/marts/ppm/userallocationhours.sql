with main as (
    select
        *
    from {{ ref('int_ppm__userallocationhours') }}
),
demand as (
    select
        *
    from {{ ref('int_ppm__demandhours') }}
),
final as (
    select
        main.start_date,
        main.end_date,
        main.allocation_id,
        main.modified_date,
        main.entityTypeId,
        main.entryDate,
        main.entryHours,
        main.type,
        demand.resource_id,
        demand.project_id as project_id,
        demand.role_id,
        demand.role_title as resource_role,
        demand.allocation_type_title as allocation_type
    from main

    inner join demand
    on demand.allocation_roleid=main.allocation_id
)
select * from final

