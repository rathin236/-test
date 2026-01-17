with incidents as (
    select * from {{ ref('int_intelex__incidents') }}
),

workspaces as (
    select * from {{ ref('int_intelex__workspaces') }}
),

joined as (
    select
        wks.rownum,
        wks.location_name,
        wks.location_code,
        wks.description,
        wks.city,
        wks.state_province,
        wks.country,
        wks.parent_location,
        wks.parent_location_id,
        wks.company_name,
        wks.line_business,
        inc.row_num,
        inc.record_no,
        inc.location,
        wks.location_id as workspace_location_id,
        inc.location_id as incident_location_id,
        wks.id as workspace_id,
        inc.id as incident_id,
        wks.updated as workspace_updated,
        inc.updated as incident_updated,
        inc.event_type,
        inc.severity,
        inc.case_classification,
        inc.date as incident_date,
        inc.execution_id,
        inc.system_type,
        year(inc.date) as year,
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
        end as medical_aid_incidents
    from incidents as inc
    inner join workspaces as wks
        on inc.location_id = wks.location_id
)

select * from joined
