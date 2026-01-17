with opi_gl_transactions as (
    select * from {{ ref('int_ifs_opi__gl_transactions') }}
)

select * from opi_gl_transactions
