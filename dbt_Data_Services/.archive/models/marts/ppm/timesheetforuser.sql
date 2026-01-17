with main as (
    select
        *
    from {{ ref('int_ppm__timesheetforuser') }}
),
resource as (
    select
        *
    from {{ ref('int_ppm__resource_unpacking') }}
),
project as (
    select
        *
    from {{ ref('dim_ppm__project_tbl') }}
),
task as (
    select
        *
    from {{ ref('dim_ppm__task_tbl') }}
),
userallocation as (
    select
        *
    from {{ ref('int_ppm__userallocationhours') }}
),
final as (
    select
        main.resource_id,
        resource.f_name || ' ' || resource.l_name as full_name,
        resource.resource_role,
        resource.role_id,
        main.start_date,
        main.end_date,
        main.timesheetId,
        main.billablerate,
        main.modified_date,
        main.companyId,
        main.state,
        main.entryDate,
        main.entryHours,
        main.entryId,
        main.entry_type,
        main.internalRate,
        main.isBillable,
        main.isProductive,
        main.level1Id,
        project.title as project_title,
        main.level2Id,
        task.title as task_title,
        main.level3Id
    from main

    left join resource
    on resource.entity_id=main.resource_id

    left join project
    on project.entity_id=main.level1Id

    left join task
    on task.entity_id=main.level2Id
    
)
select * from final
