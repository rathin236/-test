with datasets as (
    select 
        *
    from {{ ref('int_powerbi__datasets') }}
)
select * from datasets
