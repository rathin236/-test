with main as (
    select * from {{ ref('stg_easyvista__urgency') }}
)

select * from main
