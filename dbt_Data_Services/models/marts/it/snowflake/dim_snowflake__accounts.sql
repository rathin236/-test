with accounts as (

    select * from {{ ref('int_snowflake__accounts') }}

)

select * from accounts
