with so_order_header as (
    select * from {{ ref('stg_northscope__erpx_so_order_header') }}
    where orderstatussk <> 10
),

d365_ns_order_id as (
    select distinct
        salesid as "Order ID",
        'd365' as source_system
    from {{ ref("stg_d365__sales_table") }}

    union all

    select distinct
        orderid as "Order ID",
        'northscope' as source_system
    from {{ ref('stg_northscope__erpx_so_order_header') }}
),

remove_d365_orders_overlap as (
    select distinct
        "Order ID",
        source_system,
        count(*) over (partition by "Order ID") as cnt
    from d365_ns_order_id
),

fact_order_header as (

    select

        nsoh.orderheadersk,
        nsoh.orderid,
        nsoh.documentid,
        nsoh.ordertypesk,
        nsoh.orderstatussk,
        nsoh.workflowsk,
        nsoh.customersk,
        nsoh.billaddresssk,
        nsoh.shipaddresssk,
        nsoh.shipattentionto,
        nsoh.purchaseorder,
        nsoh.orderdate,
        nsoh.scheduledshipdate,
        nsoh.scheduleddeliverydate,
        nsoh.actualshipdate,
        nsoh.carriersk,
        nsoh.sitesk,
        nsoh.salespersonsk,
        nsoh.truck,
        nsoh.trailer,
        nsoh.sealnumber,
        nsoh.bol,
        nsoh.waybill,
        nsoh.sotrucktare,
        nsoh.trackingnumber,
        nsoh.sofreighttermsen,
        nsoh.adjustmentversion,
        nsoh.createdby,
        nsoh.createddate,
        nsoh.dataentitycompanysk,
        nsoh.allowmultipleshipments,
        nsoh.insidesalespersonsk,
        nsoh.shipaddressiscustomized,
        nsoh.masternumber,
        nsoh.paymenttermssk,
        nsoh.currencysk,
        nsoh.sofreighttermsen,
        nsoh._fivetran_synced

    from so_order_header as nsoh

    inner join remove_d365_orders_overlap as d365_olap
        on
            nsoh.orderid = d365_olap."Order ID"
            and d365_olap.cnt <= 1

)

select * from fact_order_header

/* For Testing */
-- where orderheadersk = 805395
