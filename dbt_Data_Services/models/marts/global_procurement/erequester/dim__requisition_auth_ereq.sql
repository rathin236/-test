with req_auth as (
    select * from {{ ref('int_ereq__dim_authorisation') }}
)

select * from req_auth