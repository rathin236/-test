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

pds_rebate as (
    select

        inventtransid,
        currencycode,
        sum(pdsstartingrebateamt) over (partition by inventtransid) as pdsstartingrebateamt

    from {{ ref('stg_d365__pds_rebate_table') }}
),

uom_conv as (
    select
        uom_conv.product,
        prod.displayproductnumber as itemid,
        uom_from.symbol as "FromUoM",
        uom_to.symbol as "ToUoM",
        uom_conv.factor
    from {{ ref('stg_d365__unit_of_measure_conversion') }} as uom_conv

    left join {{ ref('stg_d365__unit_of_measure') }} as uom_from
        on uom_conv.fromunitofmeasure = uom_from.recid

    left join {{ ref('stg_d365__unit_of_measure') }} as uom_to
        on uom_conv.tounitofmeasure = uom_to.recid

    left join {{ ref('stg_d365__eco_res_product') }} as prod
        on uom_conv.product = prod.recid

    where uom_conv.tounitofmeasure = '5637145330'
),

default_dimension_view as (
    select * from {{ ref('int_d365__default_dimension_view') }}
    where backingentitytype = 3665
),

fact_settlement as (
    select distinct
        slt.salesid as "Order ID",
        sll.inventtransid as "INVENT TRANS ID",
        slt.dataareaid as company,
        slt.releasestatus as "Release Status",
        slt.documentstatus as orderstatusid,
        sll.salesstatus as salesstatusid,
        sll.salestype as salestypeid,
        ind.inventlocationid as locationid,
        slt.inventlocationid as "Inventory Location ID",
        slt.inventsiteid as "Inventory Site ID",
        slt.createddatetime as "Create Date",
        slt.deliverydate as "Delivery Date",
        slt.invoiceaccount as "Invoice Account",
        cit.invoicedate as "Customer Invoice Date",
        slt.custaccount as "Customer Account",
        slt.shippingdateconfirmed as "Shipping Date Confirmed",
        slt.shippingdaterequested as "Shipping Date Requested",
        sll.itemid as "Item ID",
        slt.workersalesresponsible as "Salesperson_SK",
        sll.remainsalesphysical as "Remaining Sales Physical",
        sll.salesqty as "Sales Quantity",
        cit.qty as "Invoice Quantity",
        cit.salesunit as "Inv UOM",
        sll.salesunit as "Sales Unit",
        sll.sourcingvendaccount as "Sourcing Vender Account",
        rsl.priceadjustment_custom as "Flag_Price_Adjustment",
        itt.invoiceid as "Invoice ID",
        'USD' as "Currency",
        itt.datefinancial as "Date Financial",
        abu.value_ as "Financial Division ID",
        sll.deliverypostaladdress as "Delivery Address ID",
        cit.mcrdlvmode as "Mode",
        dateadd(hour, -3, current_timestamp()) as "Last Data Refresh",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'sll.currencycode', 'sll.lineamount') }} as "Sales Amount",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'sll.currencycode', 'sll.salesprice') }} as "Sales Price",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'cit.currencycode', 'cit.lineamount') }} as "Invoice Amount",
        {{ sales_volumes_lb('sll.salesunit', 'sll.salesqty', 'lb_conv.factor') }} as "Sales Volume (Lbs)",
        {{ sales_volumes_lb('cit.salesunit', 'cit.qty', 'lb_conv.factor') }} as "Invoice Volume (Lbs)",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'itt.currencycode', 'itt.costamountphysical') }} as "Estimated Cost",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'itt.currencycode', 'itt.costamountposted') }} as "Posted Cost",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'itt.currencycode', 'prt.pdsstartingrebateamt') }} as "Rebates",
        {{ convert_to_usd_adjusted('exr.exchangerate', 'itt.currencycode', 'itt.invoicereturned') }} as "Returned Invoice",
        null as "Order_Type_SK"

    from {{ ref('stg_d365__sales_table') }} as slt

    left join {{ ref('stg_d365__sales_line') }} as sll
        on slt.salesid = sll.salesid
            and slt.dataareaid = sll.dataareaid

    left join {{ ref('stg_d365__invent_trans_origin') }} as ito
        on sll.inventtransid = ito.inventtransid

    left join invent_trans as itt
        on ito.recid = itt.inventtransorigin

    left join {{ ref('stg_d365__retail_sales_line') }} as rsl
        on sll.recid = rsl.salesline

    left join {{ ref('stg_d365__cust_invoice_trans') }} as cit
        on sll.inventtransid = cit.inventtransid
            and itt.invoiceid = cit.invoiceid

    left join pds_rebate as prt
        on sll.inventtransid = prt.inventtransid

    left join {{ ref('stg_d365__invent_dim') }} as ind
        on sll.inventdimid = ind.inventdimid

    left join {{ ref('stg_d365__exchange_rate_currency_pair') }} as ercp1
        on sll.currencycode = ercp1.fromcurrencycode
            and ercp1.tocurrencycode = 'USD'

    left join {{ ref('stg_d365__exchange_rate') }} as exr
        on ercp1.recid = exr.exchangeratecurrencypair
            and to_char(sll.createddatetime, 'YYYY-MM-DD') between exr.validfrom and exr.validto

    left join uom_conv as lb_conv
        on sll.itemid = lb_conv.itemid
            and sll.salesunit = lb_conv."FromUoM"

    left join default_dimension_view as ddv
        on sll.defaultdimension = ddv.default_dimension

    left join {{ ref('int_d365__dim_attribute_om_business_unit') }} as abu
        on ddv.entityinstance = abu.key_

),

{% set amount_fields = ['Sales Price', 'Sales Amount', 'Invoice Amount', 'Sales Quantity', 'Sales Volume (Lbs)', 
                        'Invoice Quantity', 'Invoice Volume (Lbs)', 'Estimated Cost', 'Posted Cost', 'Rebates'] -%}

fact_cost as (
    select distinct
        fst."Order ID",
        iss.settletransid,
        fst.company,
        fst."Release Status",
        fst.orderstatusid,
        fst.salesstatusid,
        fst.salestypeid,
        fst.locationid,
        fst."Inventory Location ID",
        fst."Inventory Site ID",
        fst."Create Date",
        fst."Delivery Date",
        fst."Invoice Account",
        fst."Customer Invoice Date",
        fst."Customer Account",
        fst."Shipping Date Confirmed",
        fst."Shipping Date Requested",
        fst."Item ID",
        fst."Remaining Sales Physical",
        {% for settlement_value in amount_fields -%}
            fst."{{ settlement_value }}" / count(*) over (partition by fst."Invoice ID", fst."INVENT TRANS ID", fst."Currency")
                as "{{ settlement_value }}",
        {% endfor -%}
        fst."Inv UOM",
        fst."Sales Unit",
        fst."Sourcing Vender Account",
        fst."Flag_Price_Adjustment",
        fst."Invoice ID",
        {{ convert_to_usd_adjusted('exr1.exchangerate', 'fst."Currency"', 'iss.costamountadjustment') }} as "Adjusted Cost",
        {{ convert_to_usd_adjusted('exr1.exchangerate', 'fst."Currency"', 'iss.costamountsettled') }} as "Settled Cost",
        fst."Currency",
        fst."Returned Invoice",
        fst."Date Financial",
        fst."Financial Division ID",
        fst."Delivery Address ID",
        fst."Mode",
        fst."Last Data Refresh",
        (exr2.exchangerate / 100) as "Exchange Rate (USD-CAD)"

    from fact_settlement as fst

    left join {{ ref('stg_d365__exchange_rate_currency_pair') }} as ercp1
        on ercp1.fromcurrencycode = 'CAD'
            and ercp1.tocurrencycode = 'USD'

    left join {{ ref('stg_d365__exchange_rate') }} as exr1
        on ercp1.recid = exr1.exchangeratecurrencypair
            and to_char(fst."Create Date", 'YYYY-MM-DD') between exr1.validfrom and exr1.validto

    left join {{ ref('stg_d365__exchange_rate_currency_pair') }} as ercp2
        on ercp2.tocurrencycode = 'USD'

    left join {{ ref('stg_d365__exchange_rate') }} as exr2
        on ercp2.recid = exr2.exchangeratecurrencypair
            and to_varchar(fst."Create Date", 'YYYY-MM-DD') between exr2.validfrom and exr2.validto

    left join {{ ref('stg_d365__invent_settlement') }} as iss
        on fst."INVENT TRANS ID" = iss.inventtransid

)

select * from fact_cost

/* For Testing */
-- where "Order ID" = 'SO0000017'
