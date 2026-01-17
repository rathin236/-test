with main as (
    select
        line_business,
        country,
        state_province,
        company_name,
        parent_location as facility_name,
        parent_location_id as facility_id,
        location_name as workspace_name,
        month,
        month_number,
        year,
        'null' as case_classification,
        worked_hours,
        0 as recordable_incidents,
        0 as lost_time_incidents,
        0 as medical_aid_incidents
    from {{ ref('int_intelex__workedhours_workspace') }}

    union all

    select
        line_business,
        country,
        state_province,
        company_name,
        parent_location as facility_name,
        parent_location_id as facility_id,
        location_name as workspace_name,
        month,
        month_number,
        year,
        case_classification,
        0 as worked_hours,
        recordable_incidents,
        lost_time_incidents,
        medical_aid_incidents
    from {{ ref('int_intelex__incidents_workspaces') }}
),

unioned as (
    select
        line_business,
        country,
        state_province,
        company_name,
        facility_name,
        facility_id,
        workspace_name,
        month,
        month_number,
        year,
        sum(worked_hours) as worked_hours,
        sum(recordable_incidents) as recordable_incidents,
        sum(lost_time_incidents) as lost_time_incidents,
        sum(medical_aid_incidents) as medical_aid_incidents
    from main

    group by all
)

select * from unioned
