{%- set invent_cost_types = ['costamountphysical', 'costamountposted', 'costamountadjustment', 'costamountsettled', 'qty'] -%}

with invent_trans as (
    select

        invoiceid,
        itemid,
        invoicereturned,
        currencycode,
        datefinancial,
        inventtransorigin,
        {% for cost_type in invent_cost_types -%}
            sum({{ cost_type }}) over (partition by inventtransorigin) as {{ cost_type }} 
            {%- if not loop.last %}
                ,
            {% endif %}
        {% endfor %}

    from {{ ref('stg_d365__invent_trans') }}

    where invoiceid is not null
),

invent_settlement as (
    select

        inventtransid,
        sum(costamountadjustment) over (partition by inventtransid) as costamountadjustment,
        sum(costamountsettled) over (partition by inventtransid) as costamountsettled

    from {{ ref('stg_d365__invent_settlement') }}
),

pds_rebate as (
    select

        inventtransid,
        currencycode,
        sum(pdsstartingrebateamt) over (partition by inventtransid) as pdsstartingrebateamt

    from {{ ref('stg_d365__pds_rebate_table') }}
),

uom_conv as (
    select

        uomconv.product,
        prod.displayproductnumber as itemid,
        uomfrom.symbol as fromuom,
        uomto.symbol as touom,
        uomconv.factor

    from {{ ref('stg_d365__unit_of_measure_conversion') }} as uomconv

    left join {{ ref('stg_d365__unit_of_measure') }} as uomfrom
        on uomconv.fromunitofmeasure = uomfrom.recid

    left join {{ ref('stg_d365__unit_of_measure') }} as uomto
        on uomconv.tounitofmeasure = uomto.recid

    left join {{ ref('stg_d365__eco_res_product') }} as prod
        on uomconv.product = prod.recid

    where uomconv.tounitofmeasure = '5637145330'
),

default_dimension_view as (
    select * from {{ ref('int_d365__default_dimension_view') }}
    where backingentitytype = 3665
),

sales_line_notes as (
    select

        name as "Sales Line Notes",
        refrecid

    from {{ ref('stg_d365__docu_ref') }}
    where reftableid = 1345
),

sales_header_notes as (
    select

        name as "Sales Header Notes",
        refrecid

    from {{ ref('stg_d365__docu_ref') }}
    where reftableid = 2911
),

delivery_terms as (
    select * from {{ ref('int_global_sales__d365_delivery_terms') }}
),

fact_cost as (
    select distinct
        md5(
            concat_ws(
                '||', coalesce(sll.inventtransid, ''), coalesce(sll.salesid, ''), coalesce(sll.itemid, ''), coalesce(sll.dataareaid, '')
            )
        ) as pk_global_sales,
        sll.salesid as "Order ID",
        sll.inventtransid,
        slt.dataareaid as "Company",
        slt.releasestatus as "Release Status",
        slt.documentstatus as "Order Status ID",
        sll.salesstatus as "Sales Status ID",
        slt.salesstatus,
        sll.salestype as "Sales Type ID",
        inv.inventlocationid as "Location ID",
        inv.inventlocationid as "Inventory Location ID",
        split_part(inv.inventlocationid, '-', 1) as "Inventory Site ID",
        slt.payment as "Payment",
        slt.createddatetime as "Create Date",
        slt.deliverydate as "Delivery Date",
        slt.invoiceaccount as "Invoice Account",
        cit.invoicedate as "Customer Invoice Date",
        slt.custaccount as "Customer Account",
        slt.deliveryname as "Delivery Name",
        slt.shippingdateconfirmed as "Shipping Date Confirmed",
        slt.shippingdaterequested as "Shipping Date Requested",
        slt.modifiedby as "Modified By",
        slt.modifieddatetime as "Modified Date",
        sll.itemid as "Item ID",
        null as "Item_SK",
        slt.workersalestaker as "Salesperson_SK",
        sll.remainsalesphysical as "Remaining Sales Physical",
        {{ convert_to_usd('exr.exchangerate', 'sll.currencycode', 'sll.lineamount') }} as "Ordered Amount", --ordered
        {{ convert_to_usd('exr.exchangerate', 'cit.currencycode', 'cit.lineamount') }} as "Sales Amount", -- invoiced and shipped - total revenue
        {{ convert_to_usd('exr.exchangerate', 'sll.currencycode', 'sll.salesprice') }} as "Sales Price",
        {{ convert_to_usd('exr.exchangerate', 'cit.currencycode', 'cit.lineamount') }} as "Invoice Amount", --shipped
        null as ub_price_high,
        null as ub_price_avg,
        null as ub_price_low,
        sll.salesqty as "Ordered Qty",
        {{ sales_volumes_lb('sll.salesunit', 'sll.salesqty', 'lbconv.factor') }} as "Ordered Volume (Lbs)",
        cit.qty as "Sales Qty",
        {{ sales_volumes_lb('cit.salesunit', 'cit.qty', 'lbconv.factor') }} as "Sales Volume (Lbs)",
        {{ sales_volumes_lb('cit.salesunit', 'cit.qty', 'lbconv.factor') }} as "Invoice Volume (Lbs)",
        cit.qty as "Inv Qty",
        cit.salesunit as "Inv UOM",
        sll.salesunit as "Sales Unit",
        null as "Weight UOM",
        null as "Price UOM",
        sll.sourcingvendaccount as "Sourcing Vender Account",
        rsl.priceadjustment_custom as "Flag_Price_Adjustment",
        itt.invoiceid as "Invoice ID",
        itt.costamountphysical as "Estimated Cost",
        itt.costamountposted as "Posted Cost",
        {{ convert_to_usd('exr.exchangerate', 'itt.currencycode', 'iss.costamountadjustment') }} as "Adjusted Cost",
        itt.costamountsettled as "Settled Cost",
        {{ convert_to_usd('exr.exchangerate', 'prt.currencycode', 'prt.pdsstartingrebateamt') }} as "Rebates",
        null as "Freight Rate",
        trim(upper(cit.currencycode)) as "Currency",
        itt.invoicereturned as "Returned Invoice",
        itt.datefinancial as "Date Financial",
        abu.value_ as "Financial Division ID",
        sll.deliverypostaladdress as "Delivery Address ID",
        dlt.txt as "Delivery Terms",
        slt.purchorderformnum as "Customer PO",
        cit.mcrdlvmode as "Mode",
        dateadd(hour, -2, current_timestamp()) as "Last Data Refresh",
        1 / (err.exchangerate / 100) as "Exchange Rate (USD-CAD)",
        err.validfrom as "Valid From (USD-CAD)",
        err.validto as "Valid To (USD-CAD)",
        cast(sll.salestype as int) as "Order_Type_SK",
        sln."Sales Line Notes",
        shn."Sales Header Notes"

    from {{ ref('stg_d365__sales_line') }} as sll

    left join {{ ref('stg_d365__sales_table') }} as slt
        on sll.salesid = slt.salesid
            and sll.dataareaid = slt.dataareaid

    left join {{ ref('stg_d365__invent_trans_origin') }} as ito
        on sll.inventtransid = ito.inventtransid

    left join invent_trans as itt
        on ito.recid = itt.inventtransorigin

    left join invent_settlement as iss
        on sll.inventtransid = iss.inventtransid

    left join pds_rebate as prt
        on sll.inventtransid = prt.inventtransid

    left join {{ ref('stg_d365__retail_sales_line') }} as rsl
        on sll.recid = rsl.salesline

    left join {{ ref('stg_d365__cust_invoice_trans') }} as cit
        on sll.inventtransid = cit.inventtransid
            and itt.invoiceid = cit.invoiceid

    left join {{ ref('stg_d365__invent_dim') }} as inv
        on sll.inventdimid = inv.inventdimid
            and sll.dataareaid = inv.dataareaid

    left join {{ ref('stg_d365__exchange_rate_currency_pair') }} as curp
        on sll.currencycode = curp.fromcurrencycode
            and curp.tocurrencycode = 'USD'

    left join {{ ref('stg_d365__exchange_rate') }} as exr
        on curp.recid = exr.exchangeratecurrencypair
            and to_date(
                coalesce(cit.invoicedate, slt.shippingdaterequested, slt.createddatetime)
            ) between to_date(exr.validfrom) and to_date(exr.validto)

    left join {{ ref('stg_d365__exchange_rate_currency_pair') }} as ercp
        on ercp.tocurrencycode = 'USD'

    left join {{ ref('stg_d365__exchange_rate') }} as err
        on ercp.recid = err.exchangeratecurrencypair
            and to_date(
                coalesce(cit.invoicedate, slt.shippingdaterequested, slt.createddatetime)
            ) between to_date(err.validfrom) and to_date(err.validto)

    left join uom_conv as lbconv
        on sll.itemid = lbconv.itemid
            and sll.salesunit = lbconv.fromuom

    left join default_dimension_view as ddv
        on sll.defaultdimension = ddv.default_dimension

    left join {{ ref('int_d365__dim_attribute_om_business_unit') }} as abu
        on ddv.entityinstance = abu.key_

    left join sales_line_notes as sln
        on sll.recid = sln.refrecid

    left join sales_header_notes as shn
        on slt.recid = shn.refrecid

    left join delivery_terms as dlt
        on upper(trim(slt.dlvterm)) = dlt.code
            and upper(trim(slt.dataareaid)) = dlt.dataareaid

    qualify row_number() over (partition by sll.inventtransid order by sll.salesid, sll.itemid) = 1

)

select * from fact_cost
-- where inventtransid = '000079651'
/* For Testing */
-- where "Location ID" = '9999-0034'
