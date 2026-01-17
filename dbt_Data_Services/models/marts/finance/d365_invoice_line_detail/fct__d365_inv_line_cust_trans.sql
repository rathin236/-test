with cust_trans as (
    select * from {{ ref('int_d365__cust_invoice') }}
)

select * from cust_trans