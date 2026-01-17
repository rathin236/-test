with main as (
    select * from {{ ref('stg_easyvista__work_group') }}
)

select * from main
