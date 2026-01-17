with cust_invoice as (
    select
        sink_modified_on as lastprocessedchange_datetime,
        modifieddatetime as datalakemodified_datetime,
        salesid,
        '' as intercompanyinventtransid,
        dlvdate,
        intrastatfulfillmentdate_hu,
        inventdimid,
        inventqty,
        inventrefid,
        inventreftransid,
        inventreftype,
        inventtransid,
        invoicedate as "Invoice Date",
        invoiceid as "Invoice ID",
        itemid as "Item ID",
        lineamount as "Line Amount",
        linenum,
        name as "Description",
        priceunit,
        qty as "Quantity",
        returnarrivaldate,
        returncloseddate,
        salesprice as "Unit Price",
        salesunit as "Unit",
        sourcedocumentline,
        dataareaid as "Company",
        modifieddatetime,
        createddatetime as "Created Date",
        reversedrecid,
        dataareaid || salesid || itemid as "Company:SalesID:ItemID"
    from {{ ref('stg_d365__cust_invoice_trans') }}
    where reversedrecid = 0 and sourcedocumentline <> 0
)

select * from cust_invoice
