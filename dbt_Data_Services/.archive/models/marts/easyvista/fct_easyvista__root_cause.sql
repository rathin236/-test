with main as (
    select * from {{ ref('int_easyvista__root_cause') }}
)

select * from main
