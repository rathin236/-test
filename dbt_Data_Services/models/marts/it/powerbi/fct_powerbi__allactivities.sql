with allactivities as (
    select 
        *
    from {{ ref('int_powerbi__allactivities') }}
)
select * from allactivities
