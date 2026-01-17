with feed_store as (
    select * from {{ ref('stg_fishtalk__feed_store') }}
),

ext_feed_store_v2 as (
    select

        name as feedstorename,
        feedstoreid,
        orgunitid,
        active,
        capacity,
        feedstoretypeid

    from feed_store
)

select * from ext_feed_store_v2
