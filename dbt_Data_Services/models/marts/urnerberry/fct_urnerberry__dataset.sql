with cte as (
    select * from {{ ref('int_global_sales__urnerbarry_items') }}
)
select * from cte
