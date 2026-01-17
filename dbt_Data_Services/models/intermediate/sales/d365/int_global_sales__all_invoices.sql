with invoice_header as (
    select
        recid,
        orderaccount,
        invoiceaccount,
        invoiceid,
        salesid,
        invoiceamountmst,
        defaultdimension,
        ledgervoucher,
        payment,
        purchaseorder,
        dlvmode,
        dataareaid
    from {{ ref('stg_d365__cust_invoice_jour') }}
),

invoice_line as (
    select
        recid,
        invoiceid,
        invoicedate,
        itemid,
        name as item_name,
        currencycode,
        lineamount,
        lineamountmst,
        lineamounttax,
        qty as quantity,
        salesprice,
        salesunit,
        origsalesid,
        parentrecid,
        inventrefid,
        inventtransid
    from {{ ref('stg_d365__cust_invoice_trans') }}
),

enum_value as (
    select
        enumvalue,
        enumid,
        enumvaluename,
        enumvaluelabel
    from {{ ref('stg_d365__fds_enum_table') }}
    where enumid = 2715
),

pds_rebate_table as (
    select
        inventtransid,
        pdsprocessdate,
        sum(pdsstartingrebateamt) as pdsstartingrebateamt
    from {{ ref('stg_d365__pds_rebate_table') }}

    group by 1, 2
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

cust_trans as (
    select
        voucher,
        invoice,
        transtype,
        closed as closing_date,
        case
            when year(closed) = 1900 then 'Open'
        else 'Closed'
        end as transaction_status
    from {{ ref('stg_d365__cust_trans') }}
),

default_dimension_view as (
    select * from {{ ref('int_d365__default_dimension_view') }}
    where backingentitytype = '3665'
        and name = 'Division'
),

inv_line as (
    select
        ivh.recid,
        ivh.invoiceaccount as account_number,
        ilr.invoicedate as transaction_date,
        enum_value.enumvaluelabel as transaction_type,
        ivh.invoiceid as invoice_id,
        ivh.salesid as sales_id,
        ilr.itemid,
        ilr.item_name as transaction_description,
        ivh.ledgervoucher as voucher,
        ilr.lineamountmst as amount_usd,
        ilr.currencycode,
        ilr.quantity,
        ilr.salesunit,
        ilr.salesprice,
        {{ sales_volumes_lb('ilr.salesunit', 'ilr.quantity', 'lb_conv.factor') }} as invoice_volume_lbs,
        pds_rebate_table.pdsprocessdate as rebate_date,
        pds_rebate_table.pdsstartingrebateamt as rebate_total,
        null as exchange_adjustment,
        ivh.dataareaid,
        ivh.payment,
        ivh.purchaseorder,
        ivh.dlvmode,
        ilr.origsalesid,
        abu.value_ as financial_division_id,
        'jour' as source,
        cstr.closing_date,
        cstr.transaction_status
    from invoice_header as ivh
    left join invoice_line as ilr on ivh.recid = ilr.parentrecid
    left join cust_trans as cstr
    on ivh.ledgervoucher = cstr.voucher
    and ivh.invoiceid = cstr.invoice
    -- and ivh.invoicedate = cstr.transdate
    left join enum_value on cstr.transtype = enum_value.enumvalue

    left join lb_conv
        on ilr.itemid = lb_conv.item_id
            and ilr.salesunit = lb_conv.fromuom

    left join pds_rebate_table
        on ilr.inventtransid = pds_rebate_table.inventtransid

    left join default_dimension_view
        on ivh.defaultdimension = default_dimension_view.default_dimension

    left join {{ ref('int_d365__dim_attribute_om_business_unit') }} as abu
        on default_dimension_view.entityinstance = abu.key_
)

select * from inv_line
