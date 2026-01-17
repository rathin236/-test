with main as (
    select * from {{ ref('int_concur__report_tbl') }}
)
select * from main
