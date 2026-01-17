with base as (
    select *
    from {{ ref('stg_intelex__locations') }}
),

main as (
    select *
    from base
    where description <> 'Facility'
        or description is null
)

select * from main
