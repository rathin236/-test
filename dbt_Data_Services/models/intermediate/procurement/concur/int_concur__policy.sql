with main as (
    select * from {{ ref('stg_concur__policy') }}
)

select * from main
