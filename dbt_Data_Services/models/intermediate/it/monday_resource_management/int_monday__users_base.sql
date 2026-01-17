with user_base as (
    select * from {{ ref('stg_monday__users') }}
),

roles_base as (
    select * from {{ ref('stg_monday__column_value') }}
    where id = 'user_jobrole_connect'
),

location_base as (
    select * from {{ ref('stg_monday__column_value') }}
    where id = 'rd_attribute_location'
),

person_bridge as (
    select
        item_id as bridge_id,
        id as user_id
    from {{ ref('stg_monday__person_team') }}
    where kind = 'person'
        and column_value_id = 'user_id'
),

joined as (
    select
        user_base.id,
        user_base.name as user_display_name,
        roles_base.display_value as user_default_role,
        location_base.text as default_location,
        user_base.is_guest,
        user_base.enabled as is_enabled,
        user_base.country_code,
        user_base.photo_original,
        user_base.created_at,
        lower(user_base.email) as user_email,
        abs(hash(roles_base.display_value)) as role_id,
        abs(hash(user_base.id, roles_base.display_value)) as user_sk
    from user_base

    left join person_bridge
    on user_base.id = person_bridge.user_id

    left join roles_base
    on person_bridge.bridge_id = roles_base.item_id

    left join location_base
    on person_bridge.bridge_id = location_base.item_id
),

roles as (
    select distinct
        null as id,
        null as user_display_name,
        user_default_role,
        null as default_location,
        null as is_guest,
        null as is_enabled,
        null as country_code,
        null as photo_original,
        '2025-01-01' as created_at,
        null as user_email,
        role_id,
        abs(hash('', user_default_role)) as user_sk
    from joined

    where user_default_role <> ''
),

unioned as (
    select * from joined
    union all
    select * from roles
)

select * from unioned
