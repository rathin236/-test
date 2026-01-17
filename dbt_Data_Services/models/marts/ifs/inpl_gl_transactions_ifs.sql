with inpl_gl_transactions as (
    select * from {{ ref('int_ifs_inpl__gl_transactions') }}
)

select * from inpl_gl_transactions
