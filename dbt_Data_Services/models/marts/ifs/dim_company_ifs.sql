with dim_company as (
    select * from {{ ref('int_ifs__dim_company') }}

)

select * from dim_company
