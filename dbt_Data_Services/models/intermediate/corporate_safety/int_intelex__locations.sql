with base as (
    select
        rownum,
        location_name,
        location_id,
        location_code,
        description,
        city,
        state_province,
        country,
        parent_location,
        parent_location_id,
        company_name,
        line_business,
        updated,
        id
    from {{ ref('stg_intelex__locations') }}
),

ranked as (
    select
        rownum,
        location_name,
        location_id,
        location_code,
        description,
        city,
        state_province,
        country,
        parent_location,
        parent_location_id,
        company_name,
        line_business,
        updated,
        id
    from base
    qualify row_number() over (
        partition by location_id
        order by updated desc
    ) = 1
)

select
    rownum,
    location_name,
    location_id,
    location_code,
    description,
    city,
    state_province,
    country,
    parent_location,
    parent_location_id,
    company_name,
    line_business,
    updated,
    id
from ranked
