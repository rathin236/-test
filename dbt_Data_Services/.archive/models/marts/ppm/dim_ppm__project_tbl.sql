with project as (
    select *
    from {{ ref('int_ppm__project_unpacking') }}
)

select * from project
