with main as (
    select * from {{ ref('int_pronto__all_trans') }}
)
select * from main
