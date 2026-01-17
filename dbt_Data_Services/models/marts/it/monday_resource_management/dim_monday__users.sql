with

users as (
    select * from {{ ref('int_monday__users') }}
)

select * from users
