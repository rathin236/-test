with main as (
    select * from {{ ref('int_pronto__pallets') }}
)
select * from main
