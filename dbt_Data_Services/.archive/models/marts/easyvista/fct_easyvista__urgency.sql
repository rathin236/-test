with main as (
    select * from {{ ref('int_easyvista__urgency') }}
)

select * from main
