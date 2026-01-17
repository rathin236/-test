with dim_item as (
    select * from {{ ref('int_ifs__dim_item') }}

)

select * from dim_item
