with users as (
    select *
    from {{ ref('int_ppm__user_unpacking') }}
),
resources as (
    select *
    from {{ ref('int_ppm__resource_unpacking') }}
),
final as (
    select
        users.entity_name,
        users.entity_id,
        a.resource_role,
        a.role_id,
        b.supervisor_id as supervisor_id,
        concat(b.f_name,' ',b.l_name) as supervisor_name,
        users.isactive,
        users.hasadminaccess,
        CONCAT(SPLIT_PART(users.fullnamelastfirst, ', ', 2), ' ', SPLIT_PART(users.fullnamelastfirst, ', ', 1)) AS fullnamelastfirst,
        users.createdate,
        users.getprimaryemail,
        users.lastlogin,
        users.paactivationdate,
        users.padeactivationdate,
        users.typeid
    from users

    left join resources a
    on a.entity_id=users.entity_id

    left join resources b
    on a.supervisor_id = b.entity_id

    
)

select * from final
