with main as (
    select * from {{ ref('stg_concur__location') }}
)

select * from main
