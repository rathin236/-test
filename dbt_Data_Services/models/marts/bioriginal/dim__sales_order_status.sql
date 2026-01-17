with os as (

    select

        sales_order_status,
        order_number

    from {{ ref("int_sales_order_status__unioned") }}

),

prod_status as (

    select * from {{ ref("bioriginal__product_status") }}

),

joined as (

    select

        os.sales_order_status,
        sales_order_status_name,
        sales_order_status_summary,
        order_number

    from os

    left join prod_status on os.sales_order_status = prod_status.sales_order_status

)

select * from joined order by order_number
