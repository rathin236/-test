with

donations as (
    select * from {{ ref('int_finance__donations') }}
)

select * from donations
