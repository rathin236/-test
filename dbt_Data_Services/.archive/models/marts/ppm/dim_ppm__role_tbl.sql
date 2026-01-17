with main as (
    select distinct
        resource_role,
        role_id
    from {{ ref('dim_ppm__user_tbl') }}
)

select * from main
