with calendar as (
    select *
    from {{ ref('dim_date') }}
),

project as (
    select *
    from {{ ref('int_ppm__project_unpacking') }}
),

final as (
    select
        project.*,
        concat('Q', quarter(calendar."Key_Date")) as project_quarter,
        year(calendar."Key_Date") as project_year,
        concat(year(calendar."Key_Date"), quarter(calendar."Key_Date")) as sort
    from calendar

    inner join project
        on calendar."Key_Date" between project.start_date and project.target_date_reporting

)

select * from final
