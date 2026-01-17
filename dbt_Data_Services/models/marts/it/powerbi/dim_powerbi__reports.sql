with reports as (
    select 
        *
    from {{ ref('int_powerbi__reports') }}
)
select * from reports
