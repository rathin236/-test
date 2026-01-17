with main as (
    select * from {{ ref('stg_concur__payment_type') }}
)

select * from main
