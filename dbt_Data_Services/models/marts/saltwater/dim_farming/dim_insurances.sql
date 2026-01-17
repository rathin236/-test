with insurance_profile as (
    select * from {{ ref('int_ft__cai__insurance_profile') }}
)

select * from insurance_profile
