with main as (
    select * from {{ ref('stg_easyvista__impacts') }}
)

select * from main
