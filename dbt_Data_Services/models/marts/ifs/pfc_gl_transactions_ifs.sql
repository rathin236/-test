with pfc_gl_transactions as (
    select * from {{ ref('int_ifs_pfc__gl_transactions') }}
)

select * from pfc_gl_transactions
