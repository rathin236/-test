{{ config(materialized='table') }}

with valid_schemas as (
    select table_schema as name
    from gp.information_schema.tables as t1
    where table_catalog = 'GP'
    and table_name = 'GL00105'
    and exists (
        select 1
        from gp.information_schema.tables as t2
        where t1.table_schema = t2.table_schema
        and t2.table_name = 'GL00100'
    )
    and exists (
        select 1
        from gp.information_schema.tables as t3
        where t1.table_schema = t3.table_schema
        and t3.table_name = 'GL40200'
    )
    and exists (
        select 1
        from gp.information_schema.tables as t4
        where t1.table_schema = t4.table_schema
        and t4.table_name = 'GL20000'
    )
    and exists (
        select 1
        from gp.information_schema.tables as t5
        where t1.table_schema = t5.table_schema
        and t5.table_name = 'GL30000'
    )
)

select * from valid_schemas
