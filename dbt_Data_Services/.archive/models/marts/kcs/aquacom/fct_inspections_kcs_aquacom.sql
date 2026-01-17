with inspections as (
    select * from {{ ref('int_kcs__inspections_aquacom') }}
)

select * from inspections
