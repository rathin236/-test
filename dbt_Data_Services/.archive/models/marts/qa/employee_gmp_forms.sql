with unioned as (

    select * from

        {{ dbt_utils.union_relations(
            relations=[ref('int_qa__bh_personal_hygiene_gmps'), ref('int_qa__fbd_employee_gmp')], source_column_name=None
        ) }}
)

select * from unioned
