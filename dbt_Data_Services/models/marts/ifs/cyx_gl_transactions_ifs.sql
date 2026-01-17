with cyx_gl_transactions as (
    select * from {{ ref('int_ifs_cyx__gl_transactions') }}
)

select * from cyx_gl_transactions
