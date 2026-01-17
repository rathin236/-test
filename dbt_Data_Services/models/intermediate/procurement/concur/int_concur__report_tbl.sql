with main as (
    select * from {{ ref('stg_concur__report') }}
)

select * from main
