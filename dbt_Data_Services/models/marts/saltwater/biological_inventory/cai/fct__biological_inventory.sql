-- models/fct_fish_with_monetary_value.sql
with fish_inventory as (
    select *
    from {{ ref('int_ft__cai__biological_inventory') }}
)

select *
from fish_inventory
-- where site_name = 'BLUE ISLAND'
