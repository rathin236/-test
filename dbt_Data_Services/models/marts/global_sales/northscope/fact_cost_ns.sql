with fact_order_item as (
    select * from {{ ref('int_global_sales__fact_order_item_northscope') }}
),

fact_order_header as (
    select * from {{ ref('int_global_sales__fact_order_header_northscope') }}
),

mf_data_entity_company as (
    select * from {{ ref('stg_northscope__erpx_mf_data_entity_company') }}
),

mf_payment_terms as (
    select * from {{ ref('stg_northscope__erpx_mf_payment_terms') }}
),

ar_customer as (
    select * from {{ ref('stg_northscope__erpx_ar_customer') }}
),

ar_customer_address as (
    select * from {{ ref('stg_northscope__erpx_ar_customer_address') }}
),

im_item as (
    select * from {{ ref('stg_northscope__erpx_im_item') }}
),

mf_currency as (
    select * from {{ ref('stg_northscope__erpx_mf_currency') }}
),

so_invoice_header as (
    select * from {{ ref('stg_northscope__erpx_so_invoice_header') }}
),

daily_exchange_rates as (
    select * from {{ ref('dim_exchange_rates') }}
),

kyriba_exchange_rates as (
    select * from {{ ref('stg_staging_prod_xref__currency_exchange_rates') }}
),

carrier as (
    select * from {{ ref('stg_northscope__erpx_so_carrier') }}
),

logistics_cost as (
    select
        orderitemsk,
        dataentitycompanysk,
        sum(totalfreight) as totalfreight
    from {{ ref('stg_northscope__erpx_im_load_transaction_item') }}
    group by all
),

freight_terms as (
    select * from {{ ref('int_global_sales__dim_freight_terms') }}
),

fact_cost as (

    select

        md5(
            concat_ws(
                '||', coalesce(soi.orderitemsk, ''), coalesce(soi.orderid, ''), coalesce(imi.itemid, ''), coalesce(mfd.companyid, '')
            )
        ) as pk_global_sales,
        soh.orderid as "Order ID",
        soi.orderitemsk as inventtransid,
        mfd.companyid as "Company",
        null as "Release Status",
        soh.orderstatussk as "Order Status ID",
        null as "Sales Status ID",
        null as "Sales Type ID",
        soi.sitesk as "Location ID",
        soi.sitesk as "Inventory Location ID",
        soi.sitesk as "Inventory Site ID",
        mfp.paymenttermname as "Payment",
        soh.createddate as "Create Date",
        soh.scheduleddeliverydate as "Delivery Date",
        soh.billaddresssk as "Invoice Account",
        null as "Customer Invoice Date",
        arc.customerid as "Customer Account",
        arca.addressname as "Delivery Name",
        null as "Shipping Date Confirmed",
        coalesce(soh.actualshipdate, soh.scheduledshipdate) as "Shipping Date Requested",
        soi.lastuser as "Modified By",
        soi.lastupdated as "Modified Date",
        imi.itemid as "Item ID",
        imi.itemsk as "Item_SK",
        soh.insidesalespersonsk as "Salesperson_SK", --salestaker field
        null as "Remaining Sales Physical",
        --ordered amount
        {{ northscope_amounts('mfc.currencyid', 'soi.orderedamount', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Ordered Amount",
        --actual revenue
        {{ northscope_amounts('mfc.currencyid', 'soi.allocatedamount', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Sales Amount",
        {{ northscope_amounts('mfc.currencyid', 'soi.itemprice', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Sales Price",
        --invoiced amount
        {{ northscope_amounts('mfc.currencyid', 'soi.invoicedamount', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Invoice Amount",
        null as ub_price_high,
        null as ub_price_avg,
        null as ub_price_low,
        iff(soh.ordertypesk = 4, soi.orderedunits * -1, soi.orderedunits) as "Ordered Qty", --qty ordered
        iff(soh.ordertypesk = 4, soi.ordered_lbs * -1, soi.ordered_lbs) as "Ordered Volume (Lbs)", --lbs ordered
        iff(soh.ordertypesk = 4, soi.allocatedunits * -1, soi.allocatedunits) as "Sales Qty", --revenue qty
        iff(soh.ordertypesk = 4, soi.allocated_lbs * -1, soi.allocated_lbs) as "Sales Volume (Lbs)", --lbs ordered
        null as "Invoice Volume (Lbs)", --na for northscope
        null as "Inv Qty", --na for northscope
        soi.uom_id as "Inv UOM",
        soi.uom_id as "Sales UOM",
        soi.so_wt_uom as "Weight UOM",
        soi.price_uom as "Price UOM",
        null as "Sourcing Vendor Account",
        null as "Flag_Price_Adjustment",
        soh.orderid as "Invoice ID",
        {{ northscope_amounts('mfc.currencyid', 'soi.settled_cost', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Estimated Cost",
        {{ northscope_amounts('mfc.currencyid', 'soi.settled_cost', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Posted Cost",
        null as "Adjusted Cost",
        {{ northscope_amounts('mfc.currencyid', 'soi.settled_cost', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Settled Cost",
        -- order type is NA for rebates
        {{ northscope_amounts('soi.rebate_currency', 'soi.rebate_amount', 'cad_to_usd.rate', 'kyr.rate', '0') }} as rebates,
        {{ northscope_amounts('mfc.currencyid', 'logistics_cost.totalfreight', 'cad_to_usd.rate', 'kyr.rate', 'soh.ordertypesk') }} as "Freight Rate",
        mfc.currencyid as "Currency",
        case
            when substring(soh.orderid, 0, 2) like '%R%' then 1
            else 0
        end as "Returned Invoice",
        invh.invoicedate as "Date Financial",
        soh.dataentitycompanysk as "Financial Division ID",
        soh.shipaddresssk as "Delivery Address ID",
        frt.description as "Delivery Terms",
        soh.purchaseorder as "Customer PO",
        carrier.carriername as "Mode",
        dateadd(hour, -2, current_timestamp()) as "Last Data Refresh",
        iff(mfc.currencyid in ('CAD', 'USD'), usd_to_cad.rate, null) as "Exchange Rate (USD-CAD)",
        iff(mfc.currencyid in ('CAD', 'USD'), usd_to_cad.effective_start, null) as "Valid From (USD-CAD)",
        iff(mfc.currencyid in ('CAD', 'USD'), usd_to_cad.effective_stop, null) as "Valid To (USD-CAD)",
        soh.ordertypesk as "Order_Type_SK"

    from fact_order_item as soi

    left join fact_order_header as soh
        on trim(soi.orderheadersk) = trim(soh.orderheadersk)

    left join mf_data_entity_company as mfd
        on soh.dataentitycompanysk = mfd.dataentitycompanysk

    left join mf_payment_terms as mfp
        on soh.paymenttermssk = mfp.paymenttermsk

    left join ar_customer as arc
        on soh.customersk = arc.customersk

    left join ar_customer_address as arca
        on soh.shipaddresssk = arca.customeraddresssk

    left join im_item as imi
        on soi.itemsk = imi.itemsk

    left join mf_currency as mfc
        on soh.currencysk = mfc.currencysk

    left join so_invoice_header as invh
        on soh.orderheadersk = invh.orderheadersk
            and invh.invoicedate is not null

    -- left join salesperson as sales
    --     on soh.salespersonsk = sales.salespersonsk

    left join carrier as carrier
        on soh.carriersk = carrier.carriersk

    left join daily_exchange_rates as cad_to_usd
        on cad_to_usd.fx_date = coalesce(invh.invoicedate, soh.actualshipdate, soh.scheduledshipdate, soh.createddate)
            and cad_to_usd.from_ccy = 'CAD'
            and cad_to_usd.to_ccy = 'USD'

    left join daily_exchange_rates as usd_to_cad
        on usd_to_cad.fx_date = coalesce(invh.invoicedate, soh.actualshipdate, soh.scheduledshipdate, soh.createddate)
            and usd_to_cad.from_ccy = 'USD'
            and usd_to_cad.to_ccy = 'CAD'

    left join kyriba_exchange_rates as kyr
        on kyr.key_date = coalesce(invh.invoicedate, soh.actualshipdate, soh.scheduledshipdate, soh.createddate)
            and mfc.currencyid = kyr.from_ccy
            and kyr.to_ccy = 'USD'

    left join logistics_cost
        on soi.orderitemsk = logistics_cost.orderitemsk
            and soi.dataentitycompanysk = logistics_cost.dataentitycompanysk

    left join freight_terms as frt
        on trim(upper(soh.sofreighttermsen)) = frt.freighttermssk
            and trim(upper(soh.dataentitycompanysk)) = frt.dataentitycompanysk

)

select * from fact_cost

/* For Testing */
-- where "Order ID" = 'TNS369843'
