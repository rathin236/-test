with warehouses as (

    select * from {{ ref('int_snowflake__warehouses') }}

)

select * from warehouses
