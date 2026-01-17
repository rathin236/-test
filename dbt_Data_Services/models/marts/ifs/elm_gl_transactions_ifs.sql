with elm_gl_transactions as (
    select * from {{ ref('int_ifs_elm__gl_transactions') }}
)

select * from elm_gl_transactions
