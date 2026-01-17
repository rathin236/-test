{{
    config(
        materialized='view'
    )
}}

with

-- Source: Active boards from Resource Planner workspace
board as (
    select
        id as board_id,
        workspace_id,
        type as board_type,
        state as board_state,
        trim(regexp_replace(name, '\\s*-?\\s*Resource Planner', '', 1, 0, 'i')) as board_name
    from {{ ref('stg_monday__board') }}
    where workspace_id = 11173027
        and type = 'board'
        and state = 'active'
),

-- Source: Items on boards
item as (
    select
        board_id,
        id as item_id,
        name as item_name
    from {{ ref('stg_monday__item') }}
),

-- Get allocation timeline column data
allocation_columns as (
    select
        board_id,
        item_id,
        id as column_id,
        value as json_value
    from {{ ref('stg_monday__column_value') }}
    where id = 'rp_timeline'
),

-- Parse allocation dates from JSON
allocation_dates as (
    select
        alloc_cols.board_id,
        alloc_cols.item_id,
        try_to_date(try_parse_json(alloc_cols.json_value):from::string) as allocation_start_date,
        try_to_date(try_parse_json(alloc_cols.json_value):to::string) as allocation_end_date
    from allocation_columns as alloc_cols
    inner join item
        on alloc_cols.board_id = item.board_id
        and alloc_cols.item_id = item.item_id
    where item.item_name = 'Allocation'
        and try_to_date(try_parse_json(alloc_cols.json_value):from::string) is not null
        and try_to_date(try_parse_json(alloc_cols.json_value):to::string) is not null
),

-- Aggregate allocation dates by board
board_allocation_dates as (
    select
        board_id,
        min(allocation_start_date) as board_start_date,
        max(allocation_end_date) as board_end_date,
        count(*) as total_allocations
    from allocation_dates
    group by board_id
),

-- Final output with board metadata and allocation date ranges
final as (
    select
        board.board_id,
        board.board_name,
        board.workspace_id,
        board.board_type,
        board.board_state,
        board_alloc_dates.board_start_date,
        board_alloc_dates.board_end_date,
        datediff(day, board_alloc_dates.board_start_date, board_alloc_dates.board_end_date) as board_duration_days,
        -- Determines if board spans or includes next year for active resource planning
        -- Example: In 2025, this captures projects that span into or start in 2026
        case
            when board_alloc_dates.board_start_date is null or board_alloc_dates.board_end_date is null then false
            when (year(board_alloc_dates.board_start_date) < 2026 and year(board_alloc_dates.board_end_date) >= 2026) then true
            when year(board_alloc_dates.board_start_date) = 2026 then true
            else false
        end as spans_current_year,
        coalesce(board_alloc_dates.total_allocations, 0) as total_allocations
    from board
    left join board_allocation_dates as board_alloc_dates
        on board.board_id = board_alloc_dates.board_id
)

select * from final
