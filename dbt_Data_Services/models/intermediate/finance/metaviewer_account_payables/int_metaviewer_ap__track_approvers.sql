with events as (
    select
        docid as transaction_id,
        cast(activityid as int) as activityid,
        createdate,
        usermessage,
        userprofileid
    from {{ ref('stg_metaviewer__journal') }}
    where activityid in (1003, 3)
),

with_prev as (
    select
        transaction_id,
        activityid,
        createdate,
        usermessage,
        userprofileid,
        lag(activityid) over (
            partition by transaction_id order by createdate
        ) as prev_activityid,
        lag(createdate) over (
            partition by transaction_id order by createdate
        ) as prev_time
    from events
),

staged as (
    select
        transaction_id,
        activityid,
        createdate,
        usermessage,
        userprofileid,
        prev_activityid,
        prev_time,
        datediff(day, prev_time, createdate) as days_since_prev,
        sum(
            case
                when activityid = 1003
                    or (activityid = 3 and prev_activityid = 3)
                    then 1
                else 0
            end
        ) over (
            partition by transaction_id order by createdate
        ) as approval_stage,
        md5(
            concat_ws(
                '||',
                coalesce(cast(transaction_id as text), ''),
                coalesce(cast(activityid as text), ''),
                coalesce(cast(createdate as text), ''),
                coalesce(cast(userprofileid as text), '')
            )
        ) as sk_user_profile
    from with_prev
)

select * from staged
order by transaction_id, createdate
