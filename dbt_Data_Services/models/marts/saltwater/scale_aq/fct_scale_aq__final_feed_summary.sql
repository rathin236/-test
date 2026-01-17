with base as (
  select
    to_date(date_stamp) as feed_date,
    site_name,
    unit_name,
    date_stamp,
    feed_use_kg,

    -- round timestamp down to 30-minute group
    lpad(cast(extract(hour from date_stamp) as string), 2, '0') || ':' ||
    case
      when extract(minute from date_stamp) < 30 then '00'
      else '30'
    end as time_group
  from {{ ref('int_scale_aq__hourly_feed_aggregated') }}
  where to_date(date_stamp) >= current_date - 3 --order by date_stamp
  order by date_stamp
),

interval_feed as (
  -- sum the feed use for each half-hour interval
  select
    feed_date,
    site_name,
    unit_name,
    time_group,
    max(feed_use_kg) as interval_feed_kg
  from base
  group by feed_date, site_name, unit_name, time_group
),

running_total as (
  -- calculating cumulative total throughout the day
  select
    *,
    max(interval_feed_kg) over (
      partition by feed_date, site_name, unit_name
      order by time_group
      rows between unbounded preceding and current row
    ) as cumulative_feed_kg
  from interval_feed
),

final as (
  select
    feed_date,
    site_name,
    unit_name,
    time_group,
    round(cumulative_feed_kg, 3) as feed_use_kg,
    case
      when feed_date = current_date then 'TODAY'
      when feed_date = current_date - 1 then 'YESTERDAY'
      when feed_date = current_date - 2 then '2 DAYS AGO'
      when feed_date = current_date - 3 then '3 DAYS AGO'
      else null
    end as daysago
  from running_total
)

select * from final
where site_name is not null
  and (
    feed_date < current_date
    or (feed_date = current_date and to_time(time_group) <= to_time(to_char(current_timestamp(), 'HH24:MI')))
  )
order by feed_date, time_group
