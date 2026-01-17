with populations as (
    select * from {{ ref('int_ft__cai__dim_populations') }}
)

select * from populations
