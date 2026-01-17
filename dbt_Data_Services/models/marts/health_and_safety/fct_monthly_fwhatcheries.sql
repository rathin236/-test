with main as (
    select * from {{ ref('int_pronto__health_and_safety__monthly_fwhatcheries') }}
)

select * from main
