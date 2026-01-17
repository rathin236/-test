with localities as (
    select * from {{ ref('int_kcs__localities_kcs_aquacom') }}
)

select * from localities
