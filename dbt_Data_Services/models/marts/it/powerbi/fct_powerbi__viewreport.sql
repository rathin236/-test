with viewreport as (
    select 
        *
    from {{ ref('int_powerbi__viewreport') }}
)
select * from viewreport
