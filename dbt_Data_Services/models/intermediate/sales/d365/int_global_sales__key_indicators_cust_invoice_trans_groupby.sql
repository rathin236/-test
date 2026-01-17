with pds_rebate_table as (
    select
        inventtransid,
        pdsprocessdate,
        sum(pdsstartingrebateamt) as pdsstartingrebateamt
    from {{ ref('stg_d365__pds_rebate_table') }}

    group by 1, 2
),

default_dimension_view as (
    select * from {{ ref('int_d365__default_dimension_view') }}
    where backingentitytype = '3665'
        and name = 'Division'
),

lb_conv as (
    select
        uom_conv.product,
        prod.displayproductnumber as item_id,
        uom_from.symbol as fromuom,
        uom_to.symbol as touom,
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

sales_header as (
    select distinct
        sales_header."Order ID",
        sales_header."Item ID",
        sales_header."Invoice ID",
        sales_header."Release Status",
        sales_header."Order Status ID",
        sales_header."Sales Status ID",
        sales_header."Sales Type ID",
        sales_header."Inventory Location ID",
        sales_header."Inventory Site ID",
        sales_header."Delivery Address ID"
    from {{ ref('int_global_sales__fact_cost_d365') }} as sales_header
),

cust_invoice_trans_group_by as (
    select
        cust_invoice_trans.itemid,
        cust_invoice_trans.salesid,
        cust_invoice_trans.invoiceid,
        cust_invoice_trans.createddatetime,
        cust_invoice_trans.currencycode,
        cust_invoice_trans.defaultdimension,
        sales_header."Release Status",
        sales_header."Order Status ID",
        sales_header."Sales Status ID",
        sales_header."Sales Type ID",
        sales_header."Inventory Location ID",
        sales_header."Inventory Site ID",
        sales_header."Delivery Address ID",
        abu.value_ as financial_division_id,
        pds_rebate_table.pdsprocessdate as rebate_date,
        sum(cust_invoice_trans.lineamount) as lineamount_total,
        sum(cust_invoice_trans.lineamountmst) as lineamountmst_total,
        sum(cust_invoice_trans.lineamounttax) as lineamount_tax,
        sum(cust_invoice_trans.lineamounttaxmst) as lineamount_tax_mst,
        sum(pds_rebate_table.pdsstartingrebateamt) as rebate_total,
        {{ sales_volumes_lb('cust_invoice_trans.salesunit', 'cust_invoice_trans.qty', 'lb_conv.factor') }} as invoice_volume_lbs,
        cust_invoice_trans.qty,
        cust_invoice_trans.salesunit as uom

    from {{ ref('stg_d365__cust_invoice_trans') }} as cust_invoice_trans

    left join pds_rebate_table
        on cust_invoice_trans.inventtransid = pds_rebate_table.inventtransid

    left join lb_conv
        on cust_invoice_trans.itemid = lb_conv.item_id
            and cust_invoice_trans.salesunit = lb_conv.fromuom

    left join default_dimension_view
        on cust_invoice_trans.defaultdimension = default_dimension_view.default_dimension

    left join {{ ref('int_d365__dim_attribute_om_business_unit') }} as abu
        on default_dimension_view.entityinstance = abu.key_

    left join sales_header
        on cust_invoice_trans.salesid = sales_header."Order ID"
            and cust_invoice_trans.itemid = sales_header."Item ID"
            and cust_invoice_trans.invoiceid = sales_header."Invoice ID"

    group by all

)

select * from cust_invoice_trans_group_by

/* For Testing */
-- where salesid = 'SO0022558' and itemid = 'P1000002'
