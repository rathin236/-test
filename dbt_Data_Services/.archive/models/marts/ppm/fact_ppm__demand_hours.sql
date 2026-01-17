with main as (
    select
        *
    from {{ ref('int_ppm__demandhours') }}
)
select * from main