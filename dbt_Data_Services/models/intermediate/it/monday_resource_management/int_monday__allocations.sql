with board as (
    select * from {{ ref('stg_monday__board') }}
    where workspace_id = 11173027
      and type = 'board'
      and state = 'active'
),

item as (
    select * from {{ ref('stg_monday__item') }}
),

column_definitions as (
    select * from {{ ref('stg_monday__columns') }}
),

column_values as (
    select * from {{ ref('stg_monday__column_value') }}
),

person_team as (
    select * from {{ ref('stg_monday__person_team') }}
    where column_value_id = 'user_id'
),

users as (
    select * from {{ ref('int_monday__users_base') }}
),

datedim as (
    select * from {{ ref('stg_ancillary__calendar') }}
),

board_joined as (
    select
        board.id as board_id,
        board.name as board_name,
        item.id as item_id,
        item.name as item_name,
        column_definitions.id as column_id,
        column_definitions.title as column_title,
        column_values.text as column_text,
        column_values.value as raw_column_value
    from board
    inner join item on board.id = item.board_id
    left join column_definitions
      on item.board_id = column_definitions.board_id
    left join column_values
      on item.id = column_values.item_id
     and item.board_id = column_values.board_id
     and column_definitions.id = column_values.id
),

pivoted as (
  select
    board_id,
    board_name,
    item_id,
    item_name,
    max(case when column_id = 'rp_timeline' then try_parse_json(raw_column_value) end) as item_timeline,
    max(case when column_id = 'rp_assignee' then try_parse_json(raw_column_value) end) as item_assignee,
    max(case when column_id = 'rp_placeholder' then try_parse_json(raw_column_value) end) as item_placeholder,
    max(case when column_id = 'rp_total_effort' then column_text end) as total_effort,
    max(case when column_id = 'rp_effort_per_day' then column_text end) as effort_hours_per_day
  from board_joined
  group by all
),

flattened as (
  select
    piv.board_id,
    piv.board_name,
    piv.item_id,
    piv.total_effort,
    piv.effort_hours_per_day,
    try_to_date(piv.item_timeline:from::string) as timeline_start,
    try_to_date(piv.item_timeline:to::string) as timeline_end,
    piv.item_assignee:linkedPulseIds[0].linkedPulseId as linkedpulse,
    piv.item_placeholder:linkedPulseIds[0].linkedPulseId as assigned_user_placeholder
  from pivoted as piv
  where piv.item_name = 'Allocation'
),

users_joined as (
  select
    alloc_flat.board_id,
    alloc_flat.board_name,
    alloc_flat.item_id,
    alloc_flat.timeline_start,
    alloc_flat.timeline_end,
    alloc_flat.linkedpulse,
    alloc_flat.assigned_user_placeholder,
    alloc_flat.total_effort,
    alloc_flat.effort_hours_per_day,
    person_bridge.id as person_id,
    users_dim.role_id,
    case
        when alloc_flat.linkedpulse is null then abs(hash('', placeholder_item.name))
        else users_dim.user_sk
    end as user_sk,
    case
        when alloc_flat.linkedpulse is not null then users_dim.user_display_name
    end as resource_name,
    case
        when alloc_flat.linkedpulse is null then placeholder_item.name
        else users_dim.user_default_role
    end as role_name
  from flattened as alloc_flat

  left join person_team as person_bridge
  on alloc_flat.linkedpulse = person_bridge.item_id
  left join users as users_dim
  on person_bridge.id = users_dim.id
  left join item as placeholder_item
  on alloc_flat.assigned_user_placeholder = placeholder_item.id
),

date_pivot as (
select
  alloc_users.board_id,
  alloc_users.board_name,
  alloc_users.item_id,
  date_dim."Key_Date" as work_date,
  alloc_users.linkedpulse,
  alloc_users.assigned_user_placeholder,
  alloc_users.person_id as user_id,
  alloc_users.resource_name,
  alloc_users.role_name,
  alloc_users.user_sk,
  case
    when dayofweek(date_dim."Key_Date") in (0, 6) then 0
    else alloc_users.effort_hours_per_day
  end as effort_hours_per_day,
  md5(
      concat(
          coalesce(trim(alloc_users.board_id), ''),
          '|',
          coalesce(trim(alloc_users.item_id), ''),
          '|',
          coalesce(trim(date_dim."Key_Date"), ''),
          '|',
          coalesce(trim(alloc_users.user_sk), '')
      )
  ) as fact_monday_allocations_pk
from users_joined as alloc_users
inner join datedim as date_dim
  on date_dim."Key_Date" between alloc_users.timeline_start and alloc_users.timeline_end
where 1 = 1
    and alloc_users.total_effort <> ''
    and alloc_users.timeline_start is not null
    and alloc_users.timeline_end is not null
)

select * from date_pivot
