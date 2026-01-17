with requisition as (
    select * from {{ ref('int_ereq__dim_requisition') }}
)

select * from requisition