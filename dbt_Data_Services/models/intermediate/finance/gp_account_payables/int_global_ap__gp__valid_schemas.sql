with tables as (
    select
        upper(table_catalog) as table_catalog,
        upper(table_schema) as table_schema,
        upper(table_name) as table_name
    from {{ ref('stg_gp_information_schema__tables') }}
    where table_type = 'BASE TABLE'
),

need as (
    select * from (
        values
        ('PM20000'), ('PM00200'), ('PM30200'), ('MC40000'), ('MC020103'), ('PM10000')
    ) as v (table_name)
),

present as (
    select
        tbl.table_schema,
        tbl.table_name
    from tables as tbl
    where tbl.table_name in (select table_name from need)
),

agg as (
    select
        table_schema,
        count(distinct table_name) as cnt
    from present
    group by 1
)

select table_schema
from agg
where cnt = (select count(*) from need)
order by 1
