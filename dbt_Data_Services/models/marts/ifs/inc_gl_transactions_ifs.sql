with inc_gl_transactions as (
    select * from {{ ref('int_ifs_inc__gl_transactions') }}
)

select * from inc_gl_transactions
