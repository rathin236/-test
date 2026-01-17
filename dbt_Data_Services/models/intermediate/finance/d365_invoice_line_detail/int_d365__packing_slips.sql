with sales_line as (
    select *
    from {{ ref('stg_d365__sales_line') }}
),

invent_trans_origin as (
    select *
    from {{ ref('stg_d365__invent_trans_origin') }}
),

cps as (
    select * from {{ ref('stg_d365__cust_packing_slip_trans') }}
),

cips as (
    select * from {{ ref('stg_d365__cust_invoice_packing_slip_quantity_match') }}
),

final as (
select
    sl.salesid,
    sl.linenum,
    packingslipid,
    deliverydate as "Delivery Date",
    ito.inventtransid,
    cps.dataareaid as company,
    cps.partition,
    cps.qty as "Delivered QTY",
    cps.salesunit as "Sales Unit",
    cps.sourcedocumentline,
    invoicesourcedocumentline,
    cps.dataareaid || ito.inventtransid || cps.partition as "Packing Slip Key"
    from
    sales_line as sl
    inner join invent_trans_origin as ito on sl.inventtransid = ito.inventtransid
    inner join cps on sl.inventtransid = cps.inventtransid
    and sl.dataareaid = cps.dataareaid
    and sl.partition = cps.partition
    inner join cips on cps.sourcedocumentline = cips.packingslipsourcedocumentline
)

select * from final
