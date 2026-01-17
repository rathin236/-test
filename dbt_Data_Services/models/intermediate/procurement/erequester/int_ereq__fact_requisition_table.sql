/*******************************************************************************************************************************************
    PO Creation information from erequester
    Data filtered only for last 5 years
*******************************************************************************************************************************************/

with requision_line as ( --contains the item level details of each requisition
    select
        reql.companyid as company_id,
        reql.requisitionid as requisition_id,
        reql.requisitionlineid as requisition_line_id,
        reql.vendorid as vendor_id,
        reql.glaccountid as line_gl_account_id,
        reql.glaccountdesc as line_gl_account_desc,
        reql.vendorname as vendor_name,
        reql.vendorclassid as line_vendor_class,
        reql.paymenttermsid as line_payment_term,
        reql.itemid as line_item_id,
        reql.description as line_item_description,
        reql.currencykey as line_currency,
        reql.quantity as line_qty,
        reql.price as line_cost,
        reql.taxamount as line_tax,
        reql.exchangerate as line_exchange_rate,
        reql.convertedcost as line_converted_cost,
        reql.convertedtax as line_converted_tax,
        reql.taxschedule as line_tax_schedule,
        reql.taxrate as line_tax_rate,
        reql.uom as line_unit_measure,
        reql.locationid as line_location,
        reql.poid as req_line_po_id
    from {{ ref("stg_erequester__requisition_line") }} as reql
    left join {{ ref('stg_erequester__requisition') }}
    where daterequested > '2020-12-31'
),

requisition as ( --requisition header
    select
        companyid as company_id,
        requisitionid as requisition_id,
        popostedby as user_id,
        poid as requisition_po_id,
        requisitiontypeid as requisition_type_id,
        requesttypeid as request_type_id,
        statusid as status_id,
        deptid as dept_id,
        contactname as requester,
        title as contact_title,
        daterequested as requisition_datetime,
        cast(daterequested as date) as requisition_date,
        datesubmitted as submitted_datetime,
        cast(datesubmitted as date) as submitted_date,
        dateapproved as datetime_approved_last,
        cast(dateapproved as date) as date_approved_last,
        deleted as requisition_deleted,
        popostdate as datetime_posted_po,
        cast(popostdate as date) as date_posted_po,
        upper(trim(notes)) as requisition_notes
    from {{ ref('stg_erequester__requisition') }}
where daterequested > '2020-12-31'
),

requisition_status as (
    select
        requisitionstatusid as requisition_status_id,
        description as status_name
    from {{ ref('stg_erequester__requisition_status') }}
),

dept as (
    select
        companyid as company_id,
        deptid as dept_id,
        description as department_name
    from {{ ref('stg_erequester__dept') }}
),

requisition_type as (
    select
        requisitiontypeid as requisition_type_id,
        description as requisition_type_name
    from {{ ref('stg_erequester__requisition_type') }}
),

request_type as (
    select
        requesttypeid as request_type_id,
        description as request_type_name
    from {{ ref('stg_erequester__request_type') }}
),

usr as (
    select
        userid as user_id,
        upper(concat(trim(firstname), ' ', trim(lastname))) as requested_by
    from {{ ref('stg_erequester__user') }}
),

req_to_po as (
    select
        requisitionid as requisition_id,
        ponumber as requisition_po_number,
        try_cast(poid as int) as requisition_po_id
    from {{ ref('stg_erequester__reqtopo') }}
),

fxrates_cad as (
    select * from {{ ref('int_ancillary__daily_exchange_rates') }}
    where from_ccy = 'CAD' and to_ccy = 'USD'
order by fx_date asc
),

ereq_companies as (
    select * from {{ ref('int_ereq__dim_company') }}
),

requisition_data as (
    select distinct
        rql.requisition_id,
        rql.company_id,
        d.dept_id,
        req.user_id as requested_by_id, -- used as buyer in power bi
        usr.requested_by,
        req.requisition_notes as notes,
        req.status_id,
        rs.status_name,
        req.requester, -- the requester of a PO
        req.contact_title,
        req.requisition_datetime as datetime_requisition,
        req.requisition_date as date_requisition,
        req.submitted_datetime as datetime_submitted,
        req.submitted_date as date_submitted,
        req.datetime_posted_po,
        req.date_posted_po,
        req.datetime_approved_last,
        req.date_approved_last,
        req.request_type_id,
        rtt.request_type_name as request_type,
        req.requisition_deleted as requisition_isdeleted,
        req_to_po.requisition_po_id,
        req_to_po.requisition_po_number,
        rql.requisition_line_id as line_id,
        rql.line_item_description as line_desc,
        rql.vendor_id as line_vendor_id,
        rql.vendor_name as line_vendor_name,
        rql.line_vendor_class,
        rql.line_payment_term,
        rql.line_item_id,
        rql.line_item_description,
        rql.line_currency as line_currency_id,
        rql.line_currency,
        rql.line_qty as line_quant,
        rql.line_cost,
        rql.line_tax,
        rql.line_exchange_rate,
        rql.line_converted_cost as line_cost_converted,
        rql.line_converted_tax as line_tax_converted,
        rql.line_tax_schedule,
        rql.line_tax_rate,
        rql.line_unit_measure,
        rql.line_location,
        rql.line_gl_account_id,
        rql.line_gl_account_desc as line_gl_account,
        (rql.line_cost * rql.line_qty) as line_subtotal,
        (rql.line_cost * rql.line_qty) + rql.line_tax as line_total,
        (rql.line_converted_cost * rql.line_qty) as line_subtotal_converted,
        (rql.line_converted_cost * rql.line_qty) + rql.line_converted_tax as line_total_converted,
        case
            when rql.company_id in (2, 3, 7, 8, 10, 12, 26, 30) then (rql.line_cost) * fx_c.rate -- reporting currency is CAD, so everything converted back to CAD
            when rql.company_id in (9, 11, 15, 19, 24, 25, 27, 29) then rql.line_cost -- reporting currency is USD, so everything converted back to USD           
        end as line_cost_usd,
        case
            when rql.company_id in (2, 3, 7, 8, 10, 12, 26, 30) then (rql.line_cost * rql.line_qty) * fx_c.rate -- reporting currency is CAD, so everything converted back to CAD
            when rql.company_id in (9, 11, 15, 19, 24, 25, 27, 29) then rql.line_cost * rql.line_qty -- reporting currency is USD, so everything converted back to USD           
        end as line_subtotal_usd,
        case
            when rql.company_id in (2, 3, 7, 8, 10, 12, 26, 30) then ((rql.line_cost * rql.line_qty) + rql.line_tax) * fx_c.rate -- reporting currency is CAD, so everything converted back to CAD
            when rql.company_id in (9, 11, 15, 19, 24, 25, 27, 29) then (rql.line_cost * rql.line_qty) + rql.line_tax -- reporting currency is USD, so everything converted back to USD           
        end as line_total_usd,
        rql.line_tax_rate / 100 as line_tax_percent,
        md5(concat(trim(upper(comp.companycode)), trim(upper(rql.vendor_id)))) as sk_vendor_global
    from requision_line as rql
    left join requisition as req on rql.company_id = req.company_id and rql.requisition_id = req.requisition_id
    left join requisition_status as rs on req.status_id = rs.requisition_status_id
    left join dept as d on req.company_id = d.company_id and req.dept_id = d.dept_id
    left join requisition_type as rt on req.requisition_type_id = rt.requisition_type_id
    left join request_type as rtt on req.request_type_id = rtt.request_type_id
    left join usr on req.user_id = usr.user_id
    left join req_to_po on req.requisition_id = req_to_po.requisition_id
    left join fxrates_cad as fx_c on req.requisition_date = fx_c.fx_date
    left join ereq_companies as comp on rql.company_id = comp.companyid
)

select * from requisition_data --where --requisition_po_number = 'PO090717' and company_id = '12' and 
-- UPPER(LEFT(TRIM(line_item_description), 10)) like UPPER(LEFT('ROBOT MOUNTING FLOOR MOUNT AT O', 10))
-- line_item_description is null
