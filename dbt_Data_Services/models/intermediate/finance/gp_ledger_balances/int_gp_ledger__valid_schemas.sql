with tables as (
    select
        upper(table_catalog) as table_catalog,
        upper(table_schema) as table_schema,
        upper(table_name) as tbl_name
    from {{ ref('stg_gp_information_schema__tables') }}
    where table_type = 'BASE TABLE'
        and lower(
            schema_name) in (
            'bhfc', 'cai', 'cap', 'causa', 'ci', 'cph', 'cos', 'gdvii', 'gmg',
            'hpi', 'kcs', 'nb601', 'nb681', 'ndhc', 'nni', 'slgp', 'sti', 'stusa',
            'tfc', 'tfci', 'tnm', 'tns', 'tnsc', 'tnsus', 'wvcl'
        )
),

need as (
    select * from (
        values
        ('GL20000'), ('GL30000'), ('PM00200'), ('POP30300'), ('MC40000')
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
