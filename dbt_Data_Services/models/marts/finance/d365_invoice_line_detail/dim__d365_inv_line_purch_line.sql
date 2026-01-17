with PurchLine as  (
    select * from {{ ref('int_d365__Purch_Line') }}
)

select * from PurchLine