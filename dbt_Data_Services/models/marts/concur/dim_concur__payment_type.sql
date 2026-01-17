with main as (
    select * from {{ ref('int_concur__payment_type') }}
)
select * from main
