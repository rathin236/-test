with main as (
    select * from {{ ref('int_concur__user') }}
)
select * from main
