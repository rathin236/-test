with erpx_so_order_header as (
    select * from {{ ref('stg_northscope__erpx_so_order_header') }}
),

erpx_ar_customer as (
    select * from {{ ref('stg_northscope__erpx_ar_customer') }}
),

tn_fresh_dim_sales_order as (
    select

        soh.orderid as "OrderID",
        soh.ordertypesk as "OrderTypeSK",
        soh.orderstatussk as "OrderStatusSK",
        soh.workflowsk as "WorkflowSK",
        soh.customersk as "CustomerSK",
        cus.customername as "CustomerName",
        soh.paymenttermssk as "PaymentTermsSK",
        soh.billaddresssk as "BillAddressSK",
        soh.shipaddresssk as "ShipAddressSK",
        soh.shipaddressline1 as "ShipAddressLine1",
        soh.shipaddressline2 as "ShipAddressLine2",
        soh.shipaddressline2 as "ShipAddressLine3",
        soh.shipcity as "ShipCity",
        soh.shipstate as "ShipState",
        soh.shipzip as "ShipZip",
        soh.shipcountry as "ShipCountry",
        soh.purchaseorder as "PurchaseOrder",
        soh.orderdate as "OrderDate",
        soh.scheduledshipdate as "ScheduledShipDate",
        soh.scheduleddeliverydate as "ScheduledDeliveryDate",
        soh.actualshipdate as "ActualShipDate",
        soh.carriersk as "CarrierSK",
        soh.sitesk as "SiteSK",
        soh.salespersonsk as "SalesPersonSK",
        soh.orderedunits as "OrderedUnits",
        soh.orderedweight as "OrderedWeight",
        soh.orderedamount as "OrderedAmount",
        soh.allocatedunits as "AllocatedUnits",
        soh.allocatedweight as "AllocatedWeight",
        soh.allocatedamount as "AllocatedAmount",
        soh.pricebasissk as "PriceBasisSK",
        soh.extendedamount as "ExtendedAmount",
        soh.currencysk as "CurrencySK"

    from erpx_so_order_header as soh

    left join erpx_ar_customer as cus
        on soh.customersk = cus.customersk

    where soh.dataentitycompanysk = 1
)

select * from tn_fresh_dim_sales_order
