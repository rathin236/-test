with osy_gl_transactions as (
    select * from {{ ref('int_ifs_osy__gl_transactions') }}
)

select * from osy_gl_transactions
