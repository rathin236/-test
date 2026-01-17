with companies as (
    select * from {{ ref('int_ft__cai__dim_companies') }}
)

select * from companies
