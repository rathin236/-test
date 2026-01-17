with tickets as (
    select *
    from {{ ref('int_easyvista__json_unpacking') }}
),

urgency as (
    select *
    from {{ ref('int_easyvista__urgency') }}
),

workgroups as (
    select *
    from {{ ref('int_easyvista__work_group') }}
),

owning_grp as (
    select *
    from {{ ref('int_easyvista__work_group') }}
),

root as (
    select *
    from {{ ref('int_easyvista__root_cause') }}
),

employees as (
    select distinct
        done_by_employee_id,
        done_by_name
    from {{ ref('int_easyvista__tickets_action') }}
    where done_by_name not like '%@%'
),

final as (
    select
        tickets.rfc_number,
        tickets.insert_date,
        tickets.modified_from,
        tickets.modified_to,
        tickets.can_be_duplicated,
        tickets.catalog_request_path,
        tickets.catalog_request_code,
        tickets.catalog_request_sd_catalog_id,
        tickets.catalog_request_title_en,
        tickets.creation_date_ut,
        tickets.delay,
        case when tickets.rfc_number like 'PRJ%' then 'Project'
            when tickets.rfc_number like 'I%' then 'Incident'
            when tickets.rfc_number like 'C%' then 'Change Request'
            when tickets.rfc_number like 'S%' then 'Service Request'
            when tickets.rfc_number like 'P%' then 'Problem Ticket'
        else 'Not Used'
        end as category,
        tickets.department_id,
        tickets.department_path,
        tickets.end_date_ut,
        tickets.e_sla_met,
        tickets.first_call_resolution,
        tickets.impact_id,
        tickets.is_financial_compted,
        tickets.is_major_incident,
        tickets.last_done_by_id,
        employees.done_by_name as last_done_by_name,
        tickets.last_update,
        tickets.location_location_en,
        tickets.location_location_id,
        tickets.location_location_path,
        tickets.location_id,
        tickets.location_path,
        tickets.max_resolution_date_ut,
        tickets.origin_tool_id,
        tickets.owner_id,
        tickets.parent_request_id,
        tickets.recipient_begin_of_contract,
        tickets.recipient_cellular_number,
        tickets.recipient_department_path,
        tickets.recipient_employee_id,
        tickets.recipient_e_mail,
        tickets.recipient_last_name,
        tickets.recipient_location_path,
        tickets.recipient_phone_number,
        tickets.recipient_id,
        tickets.reopen_processing,
        tickets.requalification_processing,
        tickets.requestor_begin_of_contract,
        tickets.requestor_department_path,
        tickets.requestor_employee_id,
        tickets.requestor_e_mail,
        tickets.requestor_last_name,
        tickets.requestor_location_path,
        tickets.requestor_phone_number,
        tickets.requestor_feedback,
        tickets.requestor_id,
        tickets.requestor_ip_address,
        tickets.requestor_phone,
        tickets.request_id,
        tickets.request_origin_id,
        tickets.sd_catalog_id,
        tickets.sd_catalog_path,
        tickets.severity_id,
        tickets.sla_id,
        tickets.status_is_help_desk,
        tickets.status_is_procurement,
        tickets.status_en,
        tickets.status_guid,
        tickets.status_id,
        tickets.submitted_by,
        tickets.e_appointment_ut,
        tickets.submit_date_ut,
        tickets.title,
        urgency.urgency_en,
        available_field_1,
        available_field_2,
        available_field_3,
        available_field_4,
        available_field_5,
        available_field_6,
        effective_change_end,
        effective_change_start,
        planned_change_start,
        planned_change_end,
        workgroups.group_en as last_group_en,
        owning_grp.group_en as owning_group_en,
        root.rootcause_en

    from tickets

    left join urgency
        on tickets.urgency_id = urgency.urgency_id

    left join workgroups
        on tickets.last_group_id = workgroups.group_id

    left join owning_grp
        on tickets.owning_group_id = owning_grp.group_id

    left join root
        on tickets.root_cause_id = root.rootcause_id

    left join employees
        on tickets.last_done_by_id = employees.done_by_employee_id


)

select * from final
