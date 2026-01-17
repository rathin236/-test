with main as (
    select * from {{ ref('int_easyvista__work_group') }}
)

select * from main
