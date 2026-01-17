with currency as (
    select * from {{ ref('currency') }}
)

select currency as "Currency" from currency
