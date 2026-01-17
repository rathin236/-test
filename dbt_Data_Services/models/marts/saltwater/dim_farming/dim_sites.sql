with sites as (
    select * from {{ ref('int_ft__cai__dim_sites') }}
)

select * from sites
