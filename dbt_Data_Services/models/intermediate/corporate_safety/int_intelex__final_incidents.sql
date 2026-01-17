with main as (
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
        0 as worked_hours,
        recordable_incidents,
        lost_time_incidents,
        medical_aid_incidents,
        environmental_incident,
        injury_illness,
        master_incident,
        near_miss,
        property_damage,
        vehicle_vessel_equipment
    from {{ ref('int_intelex__incident_facility') }}

    union all

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
        worked_hours,
        recordable_incidents,
        lost_time_incidents,
        medical_aid_incidents,
        0 as environmental_incident,
        0 as injury_illness,
        0 as master_incident,
        0 as near_miss,
        0 as property_damage,
        0 as vehicle_vessel_equipment
    from {{ ref('int_intelex__incidents_on_workedhours') }}
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
        sum(medical_aid_incidents) as medical_aid_incidents,
        sum(environmental_incident) as environmental_incident,
        sum(injury_illness) as injury_illness,
        sum(master_incident) as master_incident,
        sum(near_miss) as near_miss,
        sum(property_damage) as property_damage,
        sum(vehicle_vessel_equipment) as vehicle_vessel_equipment
    from main
    where year > year(current_date) - 5

    group by all
)

select * from unioned
