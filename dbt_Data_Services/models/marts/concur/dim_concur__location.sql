with main as (
    select * from {{ ref('int_concur__location') }}
)
select * from main
