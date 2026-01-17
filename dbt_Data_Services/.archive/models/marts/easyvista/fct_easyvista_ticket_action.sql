with main as (
    select *
    from {{ ref('int_easyvista__tickets_action') }}
),

tickets as (
    select *
    from {{ ref('int_easyvista__json_unpacking') }}
),

workgroups as (
    select *
    from {{ ref('int_easyvista__work_group') }}
),

final as (
    select
        main.rfc_number,
        main.insert_date,
        main.modified_from,
        main.modified_to,
        main.action_id,
        main.action_label_en,
        main.action_number,
        main.creation_date_ut as action_creation_date,
        main.end_date_ut as action_end_date,
        main.action_type_id,
        main.action_type_name,
        main.done_by_employee_id,
        main.done_by_email,
        main.done_by_name,
        main.group_id,
        workgroups.group_en,
        case
            when action_label_en = 'Requested Additional Assistance' then 1
            else 0 
        end as flag_task,
        row_number() over (partition by main.rfc_number order by cast(main.action_id as int), main.creation_date_ut asc) as action_seq
    from main

    left join tickets
        on main.rfc_number = tickets.rfc_number

    left join workgroups
        on main.group_id = workgroups.group_id
)

select * from final
