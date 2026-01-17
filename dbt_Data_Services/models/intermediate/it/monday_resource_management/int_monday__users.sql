with base_users as (
    select * from {{ ref('int_monday__users_base') }}
),

allocations as (
    select distinct
        role_name,
        abs(hash('', role_name)) as user_sk
    from {{ ref('int_monday__allocations') }}
    where resource_name is null
        and role_name is not null
),

existing_user_sks as (
    select distinct user_sk
    from base_users
),

new_roles_from_allocations as (
    select
        null as id,
        null as user_display_name,
        alloc.role_name as user_default_role,
        null as default_location,
        null as is_guest,
        null as is_enabled,
        null as country_code,
        null as photo_original,
        '2025-01-01' as created_at,
        null as user_email,
        abs(hash(alloc.role_name)) as role_id,
        alloc.user_sk
    from allocations as alloc
    left join existing_user_sks
        on alloc.user_sk = existing_user_sks.user_sk
    where existing_user_sks.user_sk is null
),

final as (
    select * from base_users
    union all
    select * from new_roles_from_allocations
)

select * from final
