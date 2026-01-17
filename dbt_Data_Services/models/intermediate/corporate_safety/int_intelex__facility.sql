with base as (
    select *
    from {{ ref('stg_intelex__locations') }}
),

main as (
    select *
    from base
    where description = 'Facility'
)

select * from main
