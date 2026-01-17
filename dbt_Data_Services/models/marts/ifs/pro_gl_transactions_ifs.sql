with pro_gl_transactions as (
    select * from {{ ref('int_ifs_pro__gl_transactions') }}
)

select * from pro_gl_transactions
