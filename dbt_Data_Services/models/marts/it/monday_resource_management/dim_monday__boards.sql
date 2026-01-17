with

boards as (
    select * from {{ ref('int_monday__board') }}
)

select * from boards
