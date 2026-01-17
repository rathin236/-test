with site_unit_day as (
    select distinct
        sites.site_name,
        sites.unit_name,
        date_trunc('day', items.date_time) as datestamp
    from {{ ref('int_scale_aq__items_aggregated') }} as items
    left join {{ ref('int_scale_aq__sites') }} as sites
        on items.site_id = sites.site_id and items.unit_id = sites.unit_id
),

hours as (
    select 0 as hour_of_day
    union all
    select 1
    union all
    select 2
    union all
    select 3
    union all
    select 4
    union all
    select 5
    union all
    select 6
    union all
    select 7
    union all
    select 8
    union all
    select 9
    union all
    select 10
    union all
    select 11
    union all
    select 12
    union all
    select 13
    union all
    select 14
    union all
    select 15
    union all
    select 16
    union all
    select 17
    union all
    select 18
    union all
    select 19
    union all
    select 20
    union all
    select 21
    union all
    select 22
    union all
    select 23
),

minutes as (
    select 0 as mins
    union all
    select 30 as mins
),

hour_day as (
    select
        dateadd(minute, minutes.mins, dateadd(hour, hours.hour_of_day, sud.datestamp)) as date_stamp,
        sud.site_name,
        sud.unit_name,
        0 as feed_use_kg
    from hours
    cross join minutes
    cross join site_unit_day as sud
),

-- select * from hour_day,

hourly_feed as (
    select
        case
            when to_char(items.date_time, 'hh:mm:ss') = '23:59:59' then items.date_time
            else date_trunc('minute', items.date_time)
        end as date_stamp,
        sites.site_name,
        sites.unit_name,
        max(items.item_value) / 1000 as feed_use_kg
    from {{ ref('int_scale_aq__items_aggregated') }} as items
    left join {{ ref('int_scale_aq__sites') }} as sites
        on items.site_id = sites.site_id and items.unit_id = sites.unit_id
    where items.data_type = 'FeedAmount'
    group by
        case
            when to_char(items.date_time, 'hh:mm:ss') = '23:59:59' then items.date_time
            else date_trunc('minute', items.date_time)
        end,
        sites.site_name,
        sites.unit_name
),

daily_agg as (
    select
        date_stamp,
        site_name,
        unit_name,
        max(feed_use_kg) as feed_use_kg,
        case when max(feed_use_kg) = 0 then 0 else 1 end as changeindicator
    from (
        select * from hourly_feed
        union all
        select * from hour_day
    ) as unioned_data
    group by date_stamp, site_name, unit_name
)

select * from daily_agg
