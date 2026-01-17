with main as (
    select * from {{ ref('int_concur__report_expenseentry_tbl') }}
)
select * from main
