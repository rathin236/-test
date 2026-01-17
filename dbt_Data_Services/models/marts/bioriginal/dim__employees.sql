with emp as (

    select * from {{ ref("int_employees__unioned") }}

),

stbp as (

    select * from {{ ref("int_sold_to_business_partner__unioned") }}

),

join_sales_rep as (

    select

        stbp.sales_rep_id,
        emp.sales_rep_name,
        customer_service_rep_id,
        customer_bp_id

    from stbp

    left join emp on stbp.sales_rep_id = emp.sales_rep_id

),

join_cs_rep as (

    select


        join_sales_rep.sales_rep_id,
        join_sales_rep.sales_rep_name,
        join_sales_rep.customer_service_rep_id,
        emp.sales_rep_name as customer_service_rep_name,
        customer_bp_id


    from join_sales_rep

    left join emp on join_sales_rep.customer_service_rep_id = emp.sales_rep_id

)


select * from join_cs_rep
