with

allocations as (
    select * from {{ ref('int_monday__allocations') }}
)

select * from allocations
