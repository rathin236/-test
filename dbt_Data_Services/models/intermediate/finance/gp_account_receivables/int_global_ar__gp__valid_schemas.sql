with tables as (
    select
        upper(table_catalog) as table_catalog,
        upper(table_schema) as table_schema,
        upper(table_name) as tbl_name
    from {{ ref('stg_gp_information_schema__tables') }}
    where table_type = 'BASE TABLE'
),

need as (
    select * from (
        values
        ('MC40000'), ('RM20101'), ('RM00101'), ('MC020102'), ('RM30101')
    ) as v (tbl_name)
),

present as (
    select
        tbl.table_schema,
        tbl.tbl_name
    from tables as tbl
    where tbl.tbl_name in (select tbl_name from need)
),

agg as (
    select
        table_schema,
        count(distinct tbl_name) as cnt
    from present
    group by 1
)

select table_schema
from agg
where cnt = (select count(*) from need)
order by 1
