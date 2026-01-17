with dim_supplier as (
    select * from {{ ref('int_ifs__dim_supplier') }}

)

select * from dim_supplier
