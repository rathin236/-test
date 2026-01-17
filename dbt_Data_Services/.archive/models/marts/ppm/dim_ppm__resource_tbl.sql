with resource as (
    select
        entity_name,
        entity_id,
        resource_email,
        supervisor_id,
        supervisor_name,
        resource_role,
        resource_role_id,
        f_name || ' ' || l_name as full_name
    from {{ ref('int_ppm__resource_unpacking') }}
)

select * from resource
