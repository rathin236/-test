with main as (
    select * from {{ ref('int_easyvista__impacts') }}
)

select * from main
