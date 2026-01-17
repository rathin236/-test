with base as (
    select
        rownum,
        id,
        recordno,
        location,
        location_id,
        location_code,
        month,
        year,
        number_of_incidents,
        salary_employee_hours,
        hourly_employee_hours,
        worked_hours,
        worked_hours_rolled_up,
        days_away,
        restricted_days_job_transfer,
        incident_rate,
        lost_time_incident_rate,
        dart_rate,
        severity_rate,
        execution_id,
        execution_date
    from {{ ref('stg_intelex__workhours') }}
),

ranked as (
    select *
    from base
    qualify row_number() over (partition by recordno order by execution_date desc) = 1
)

select * from ranked
