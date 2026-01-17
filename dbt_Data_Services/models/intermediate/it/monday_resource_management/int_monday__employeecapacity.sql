with calendar as (
    select * from {{ ref('stg_ancillary__calendar') }}
    where "Key_Date" between '2025-01-01' and '2028-12-31'
),

users as (
    select * from {{ ref('int_monday__users_base') }}
),

user_date as (
    select
        users.id as user_id,
        users.role_id,
        users.user_sk,
        users.user_display_name as user_name,
        users.user_email,
        users.user_default_role as user_role,
        calendar."Key_Date" as entry_date,
        case
            when users.id is null then 0
            when calendar."Name_DayOfWeekEnglish" in ('Saturday', 'Sunday') then 0
            else 7
        end as capacityhours,
        md5(concat(coalesce(trim(users.user_sk), ''), '|', coalesce(trim(calendar."Key_Date"), ''))) as fact_monday_capacity_pk
    from users
    cross join calendar
    where calendar."Key_Date" >= cast(users.created_at as date)
)

select * from user_date
