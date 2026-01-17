with sales_table_d365 as (
    select * from {{ ref('stg_d365__sales_table') }}
),

dim_orders_d365 as (
    select salesid as "Order ID" from sales_table_d365

    qualify row_number() over (partition by salesid order by salesid) = 1

    order by salesid
)

select * from dim_orders_d365
