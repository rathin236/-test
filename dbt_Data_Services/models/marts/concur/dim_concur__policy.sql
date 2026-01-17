with main as (
    select * from {{ ref('int_concur__policy') }}
)
select * from main
