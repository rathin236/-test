with localities as (
    select * from {{ ref('stg_aquacom__localities') }}
)

select * from localities
