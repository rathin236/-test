with incidents as (
    select * from {{ ref('int_intelex__incidents') }}
),

facility as (
    select * from {{ ref('int_intelex__facility') }}
),

joined as (
    select
        inc.id,
        inc.row_num,
        inc.updated,
        inc.record_no,
        inc.location as facility_name,
        inc.location_id as facility_id,
        'Facility Incident' as workspace_name,
        inc.event_type,
        inc.severity,
        inc.case_classification,
        inc.date,
        inc.status,
        inc.system_type,
        fac.line_business,
        fac.country,
        fac.state_province,
        fac.company_name,
        month(inc.date) as month_number,
        case month(inc.date)
            when 1 then 'January'
            when 2 then 'February'
            when 3 then 'March'
            when 4 then 'April'
            when 5 then 'May'
            when 6 then 'June'
            when 7 then 'July'
            when 8 then 'August'
            when 9 then 'September'
            when 10 then 'October'
            when 11 then 'November'
            when 12 then 'December'
        end as month,
        year(inc.date) as year,
        case
            when inc.case_classification in (
                    'Lost Time',
                    'Medical Aid (return to work)',
                    'Medical Aid (with restricted work)',
                    'Medical Aid (with modified work)',
                    'Medical Aid (Recordable)'
                )
                then 1
            else 0
        end as recordable_incidents,
        case
            when inc.case_classification = 'Lost Time'
                then 1
            else 0
        end as lost_time_incidents,
        case
            when inc.case_classification in (
                    'Medical Aid (with modified work)',
                    'Medical Aid (return to work)',
                    'Medical Aid (with restricted work)',
                    'Medical Aid (Recordable)'
                )
                then 1
            else 0
        end as medical_aid_incidents,
        case
            when inc.system_type = 'Environmental Incident'
                then 1
            else 0
        end as environmental_incident,
        case
            when inc.system_type = 'Injury/Illness'
                then 1
            else 0
        end as injury_illness,
        case
            when inc.system_type = 'Master Incident'
                then 1
            else 0
        end as master_incident,
        case
            when inc.system_type = 'Near Miss'
                then 1
            else 0
        end as near_miss,
        case
            when inc.system_type = 'Property Damage Incident'
                then 1
            else 0
        end as property_damage,
        case
            when inc.system_type = 'Vehicle/Vessel/Equipment Incident'
                then 1
            else 0
        end as vehicle_vessel_equipment
    from incidents as inc
    inner join facility as fac
        on inc.location_id = fac.location_id
    where inc.status <> 'Cancelled'
),

grouped as (
    select
        line_business,
        country,
        state_province,
        company_name,
        facility_name,
        facility_id,
        workspace_name,
        month_number,
        system_type,
        month,
        year,
        sum(recordable_incidents) as recordable_incidents,
        sum(lost_time_incidents) as lost_time_incidents,
        sum(medical_aid_incidents) as medical_aid_incidents,
        sum(environmental_incident) as environmental_incident,
        sum(injury_illness) as injury_illness,
        sum(master_incident) as master_incident,
        sum(near_miss) as near_miss,
        sum(property_damage) as property_damage,
        sum(vehicle_vessel_equipment) as vehicle_vessel_equipment
    from joined
    group by
        line_business,
        country,
        state_province,
        company_name,
        facility_name,
        facility_id,
        workspace_name,
        month_number,
        system_type,
        month,
        year
)

select * from grouped
