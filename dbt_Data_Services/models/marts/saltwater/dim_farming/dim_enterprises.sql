with enterprises as (
    select * from {{ ref('int_ft__cai__dim_enterprises') }}
)

select * from enterprises
