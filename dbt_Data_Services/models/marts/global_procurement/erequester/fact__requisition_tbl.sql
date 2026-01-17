with requisition as (
    select
        requisition_id,
        company_id,
        dept_id,
        requested_by_id, -- used as buyer in power bi
        requested_by,
        notes,
        status_id,
        status_name,
        requester, -- the requester of a PO
        contact_title,
        datetime_requisition,
        date_requisition,
        datetime_submitted,
        date_submitted,
        datetime_posted_po,
        date_posted_po,
        datetime_approved_last,
        date_approved_last,
        request_type_id,
        request_type,
        requisition_isdeleted,
        requisition_po_id,
        requisition_po_number,
        line_id,
        line_desc,
        line_vendor_id,
        line_vendor_name,
        line_vendor_class,
        line_payment_term,
        line_item_id,
        line_item_description,
        line_currency_id,
        line_currency,
        line_quant,
        line_cost,
        line_subtotal,
        line_tax,
        line_total,
        line_exchange_rate,
        line_cost_converted,
        line_subtotal_converted,
        line_tax_converted,
        line_total_converted,
        line_tax_schedule,
        line_cost_usd,
        line_subtotal_usd,
        line_total_usd,
        line_tax_rate,
        line_tax_percent,
        line_unit_measure,
        line_location,
        line_gl_account_id,
        line_gl_account,
        sk_vendor_global
from {{ ref("int_ereq__fact_requisition_table") }}
),

FXRates as (
    select * from {{ ref('int_ancillary__daily_exchange_rates') }}
    where from_ccy = 'USD' and to_ccy = 'CAD' order by FX_Date asc
),

CAD as (
    select
        req.requisition_id,
        req.company_id,
        req.dept_id,
        req.requested_by_id, -- used as buyer in power bi
        req.requested_by,
        req.notes,
        req.status_id,
        req.status_name,
        req.requester, -- the requester of a PO
        req.contact_title,
        req.datetime_requisition,
        req.date_requisition,
        req.datetime_submitted,
        req.date_submitted,
        req.datetime_posted_po,
        req.date_posted_po,
        req.datetime_approved_last,
        req.date_approved_last,
        req.request_type_id,
        req.request_type,
        req.requisition_isdeleted,
        req.requisition_po_id,
        req.requisition_po_number,
        req.line_id,
        req.line_desc,
        req.line_vendor_id,
        req.line_vendor_name,
        req.line_vendor_class,
        req.line_payment_term,
        req.line_item_id,
        req.line_item_description,
        req.line_currency_id,
        req.line_currency,
        req.line_quant,
        req.line_cost,
        req.line_subtotal,
        req.line_tax,
        req.line_total,
        req.line_exchange_rate,
        req.line_cost_converted,
        req.line_subtotal_converted,
        req.line_tax_converted,
        req.line_total_converted,
        req.line_tax_schedule,
        req.line_cost_usd,
        req.line_subtotal_usd,
        req.line_total_usd,
        req.line_tax_rate,
        req.line_tax_percent,
        req.line_unit_measure,
        req.line_location,
        req.line_gl_account_id,
        req.line_gl_account,
        case 
            when req.company_id in (2, 3, 7, 8, 10, 12, 26, 30)  then req.line_cost  -- reporting currency is CAD, so everything converted back to CAD
            when req.company_id in (9, 11, 15, 19, 24, 25, 27, 29) then req.line_cost * FX_C.rate -- reporting currency is USD, so everything converted back to USD           
        end as line_cost_cad,
        case 
            when req.company_id in (2, 3, 7, 8, 10, 12, 26, 30)  then (req.line_cost * req.line_quant)  -- reporting currency is CAD, so everything converted back to CAD
            when req.company_id in (9, 11, 15, 19, 24, 25, 27, 29) then req.line_cost * req.line_quant * FX_C.rate -- reporting currency is USD, so everything converted back to USD           
        end as line_subtotal_cad,
        case 
            when req.company_id in (2, 3, 7, 8, 10, 12, 26, 30)  then (req.line_cost * req.line_quant) + req.line_tax -- reporting currency is CAD, so everything converted back to CAD
            when req.company_id in (9, 11, 15, 19, 24, 25, 27, 29) then ((req.line_cost * req.line_quant) + req.line_tax)  * FX_C.rate -- reporting currency is USD, so everything converted back to USD           
        end as line_total_cad,
        req.sk_vendor_global,
        'E-REQUESTER' as po_origin

    from requisition req
    left join FXRates FX_C on req.date_requisition = FX_C.FX_Date
)

select * from CAD
