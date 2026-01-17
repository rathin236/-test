with expenses as (

    select * from {{ ref('int_concur__expense') }}

)

select * from expenses
