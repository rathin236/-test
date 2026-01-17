with cte as (
    select * from {{ ref('int_ereq__fct_approvals_table') }}
)
select * from cte
