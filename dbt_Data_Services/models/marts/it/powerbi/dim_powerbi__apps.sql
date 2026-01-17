with apps as (
    select 
        *
    from {{ ref('int_powerbi__apps') }}
)
select * from apps
