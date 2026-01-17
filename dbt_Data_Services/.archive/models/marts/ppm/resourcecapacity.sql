with main as (
    select
        *
    from {{ ref('int_ppm__resourcecapacity') }}
),
resource as (
    select
        *
    from {{ ref('dim_ppm__user_tbl') }}
),
final as (
    select
        main.resource_id,
        main.start_date,
        main.end_date,
        main.modified_date,
        main.entry_date,
        main.entry_hours,
        resource.role_id,
        resource.resource_role
    from main
    
    left join resource
    on resource.entity_id=main.resource_id
)
select * from final
