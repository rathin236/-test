with tables as (
    select
        upper(table_catalog) as table_catalog,
        upper(table_schema) as table_schema,
        upper(table_name) as table_name
    from {{ ref('stg_gp_information_schema__tables') }}
    where table_type = 'BASE TABLE'
        and lower(schema_name) not in (
            'bhfc', 'cai', 'cap', 'causa', 'ci', 'cph', 'cos', 'gdvii', 'gmg',
            'hpi', 'kcs', 'nb601', 'nb681', 'ndhc', 'nni', 'slgp', 'sti', 'stusa',
            'tfc', 'tfci', 'tnm', 'tns', 'tnsc', 'tnsus', 'wvcl', 'avc'
        )
),

need as (
    select * from (
        values
        ('PM00200')
    ) as valid_table_list (table_name)
),

present as (
    select
        tbl.table_schema,
        tbl.table_name
    from tables as tbl
    where tbl.table_name in (
            select valid_table_list.table_name
            from need as valid_table_list
        )
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
