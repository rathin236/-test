with

capacity as (
    select * from {{ ref('int_monday__employeecapacity') }}
)

select * from capacity
