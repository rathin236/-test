with main as (
    select * from {{ ref('stg_easyvista__root_cause') }}
)

select * from main
