with main as (
    select * from {{ ref('stg_concur__user') }}
)

select * from main
