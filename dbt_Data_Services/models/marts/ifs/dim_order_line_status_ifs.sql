with dim_order_line_status as (
    select * from {{ ref('int_ifs__dim_order_line_status') }}

)

select * from dim_order_line_status
