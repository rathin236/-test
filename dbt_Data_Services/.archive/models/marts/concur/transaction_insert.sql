with transaction_insert as (

    select * from {{ ref('int_concur__transaction_insert') }}

)

select * from transaction_insert
