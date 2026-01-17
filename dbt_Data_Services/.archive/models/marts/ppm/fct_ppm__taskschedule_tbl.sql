with taskschedule as (
    select *
    from {{ ref('int_ppm__taskschedule_unpacking') }}
),

task as (
    select *
    from {{ ref('int_ppm__task_unpacking') }}
),

project as (
    select *
    from {{ ref('int_ppm__project_unpacking') }}
),

portfolio as (
    select *
    from {{ ref('int_ppm__portfolio_unpacking') }}
),

resource as (
    select *
    from {{ ref('int_ppm__resource_unpacking') }}
),

final as (
    select
        taskschedule.entity_id as taskschedule_id,
        taskschedule.user_id as employee_id,
        taskschedule.resource_supervisor_id,
        taskschedule.scheduled_hours,
        taskschedule.actual_hours,
        taskschedule.hours_to_complete,
        taskschedule.start_date,
        taskschedule.complete_date,
        taskschedule.target_date,
        task.entity_id as task_id,
        task.title as task_title,
        task.project_id,
        portfolio.entity_id as portfolio_id,
        resource.f_name || ' ' || resource.l_name as full_name,
        resource.role_id as resource_role_id,
        resource_supervisor.f_name || ' ' || resource_supervisor.l_name as supervisor_full_name,
        project.start_date as project_start,
        project.target_date_reporting as project_target,
        project.complete_date as project_complete
    from taskschedule

    left join task
        on taskschedule.task_id = task.entity_id

    left join project
        on task.project_id = project.entity_id

    left join portfolio
        on project.portfolio_title = portfolio.title

    left join resource
        on taskschedule.user_id = resource.entity_id

    left join resource as resource_supervisor
        on taskschedule.resource_supervisor_id = resource_supervisor.entity_id
)

select * from final
