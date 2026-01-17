with date_dimension as (
    select * from {{ ref('int_ancillary__calendar') }}
)

select * from date_dimension
