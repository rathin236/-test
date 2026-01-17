with feed_receptions as (
    select * from {{ ref('stg_fishtalk__feed_receptions') }}
),

feed_reception_batches as (
    select * from {{ ref('stg_fishtalk__feed_reception_batches') }}
),

feed_batch as (
    select * from {{ ref('stg_fishtalk__feed_batch') }}
),

ext_feed_delivery_v2 as (
    select

        frc.feedreceptionid,
        frb.priceperkg as price,
        fbt.feedtypeid,
        fbt.feedbatchid,
        fbt.feedstoreid,
        frc.supplierid,
        fbt.batchnumber,
        frc.ordernumber,
        frc.receptiontime,
        frc.receptiontime::date as receptiondate,
        frc.shippingdate,
        frb.receptionamount / 1000 as amountkg

    from feed_receptions as frc

    inner join feed_reception_batches as frb
        on frc.feedreceptionid = frb.feedreceptionid

    inner join feed_batch as fbt
        on frb.feedbatchid = fbt.feedbatchid

    where frc.deliveryreasonsid = 1
)

select * from ext_feed_delivery_v2
