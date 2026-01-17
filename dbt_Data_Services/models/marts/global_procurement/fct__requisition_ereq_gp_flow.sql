with gp_data as (
    select * from {{ ref('fct_gp__po_transactions') }} -- where po_number = 'PO041727'
),

ereq as (
    select * from {{ ref('fact__requisition_tbl') }}
),

ereq_companies as (
    select * from {{ ref('int_ereq__dim_company') }}
),

gp_ereq as (
    select
        gpd.dex_row_id,
        gpd.dex_row_ts,
        gpd.company_id,
        ereq.dept_id,
        gpd.ord,
        ereq.requisition_id,
        gpd.po_number,
        ereq.requested_by_id,
        ereq.request_type_id,
        ereq.requester,
        ereq.status_id,
        ereq.contact_title,
        gpd.vendor_id,
        gpd.item_id,
        gpd.vend_item_id,
        gpd.document_type_id,
       -- ereq.line_gl_account_id,
        case 
            when ereq.requisition_id is null then gpd.req_date
            when ereq.requisition_id is null and gpd.req_date is null then gpd.prm_date
            else ereq.date_requisition
        end as date_requisition,
        ereq.date_submitted,
        case 
            when ereq.requisition_id is null then gpd.req_date
            when ereq.requisition_id is null and gpd.req_date is null then gpd.prm_date
            else ereq.date_posted_po
        end as date_posted_po, 
        ereq.date_approved_last,
        gpd.prm_date,
        gpd.req_date,
        gpd.release_by_date,
        gpd.release_date,
        gpd.qty,
        gpd.umqtyinb,
        gpd.uom_id,
        gpd.unit_cost,
        gpd.originating_unit_cost,
        gpd.originating_extended_cost,
        gpd.originating_tax_amount,
        gpd.functional_extended_cost,
        gpd.functional_tax_amount,
        gpd.transaction_currency_id,
        gpd.company_currency,
        gpd.cad_amount,
        gpd.usd_amount,
        case when trim(gpd.po_number) is not null and trim(ereq.requisition_po_number) is null then 'GP' else 'E-REQ' end as po_origin,
        gpd.source,
        md5(concat(trim(upper(comp.companycode)), trim(upper(gpd.vendor_id)))) as sk_vendor_global
        from gp_data as gpd
        left join ereq on
            trim(gpd.po_number) = trim(ereq.requisition_po_number)
            and trim(gpd.company_id) = trim(ereq.company_id)
        
        left join ereq_companies comp on gpd.company_id = comp.companyid
)

select distinct * from gp_ereq