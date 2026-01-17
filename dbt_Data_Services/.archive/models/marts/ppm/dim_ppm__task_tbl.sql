with task as (
    select *
    from {{ ref('int_ppm__task_unpacking') }}
)

select * from task
