with containers as (
    select * from {{ ref('int_ft__cai__dim_containers') }}
)

select * from containers
