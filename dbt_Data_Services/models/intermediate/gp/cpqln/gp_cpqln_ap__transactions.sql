-- GP tables (per Victoria Yudin naming):
-- PM20000 = Open Payables Transactions
-- PM30200 = Historical Payables Transactions
-- PM10100 = Payables Distribution Work/Open
-- PM30600 = Payables Distribution History
-- PM00200 = Vendor Master
-- GL00100 = Account Master
-- EXT01103 / EXT01100 = Extender tables (used for "paid in USD" flag)

with company as (
    select *
    from {{ ref('stg_gp__company_name') }}
),

company_cpqln as (
    select
        company.company_name,
        company.interid
    from company
    where ltrim(rtrim(company.interid)) = 'CPQLN'
    qualify row_number() over (order by company.company_name) = 1
),

mc40000 as (
    select ltrim(rtrim(mc40000_source.funlcurr)) as functional_currency
    from {{ ref('stg_gp_cpqln__mc40000') }} as mc40000_source
    qualify row_number() over (order by mc40000_source.funlcurr) = 1
),

pm20000 as (
    select *
    from {{ ref('stg_gp_cpqln__pm20000') }}
),

pm30200 as (
    select *
    from {{ ref('stg_gp_cpqln__pm30200') }}
),

pm10100 as (
    select *
    from {{ ref('stg_gp_cpqln__pm10100') }}
),

pm30600 as (
    select *
    from {{ ref('stg_gp_cpqln__pm30600') }}
),

pm00200 as (
    select *
    from {{ ref('stg_gp_cpqln__pm00200') }}
),

gl00100 as (
    select *
    from {{ ref('stg_gp_cpqln__gl00100') }}
),

ext01103 as (
    select *
    from {{ ref('stg_gp_cpqln__ext01103') }}
),

ext01100 as (
    select *
    from {{ ref('stg_gp_cpqln__ext01100') }}
),

extender as (
    select
        ext01103.extender_record_id,
        ext01103.total as paid_in_usd,
        ext01100.extender_key_values_1 as vendorid
    from ext01103
    inner join ext01100
        on ext01103.extender_record_id = ext01100.extender_record_id
    where ext01103.field_id = 138
),

doc_headers as (
    select
        pm20000.curncyid,
        pm20000.docnumbr,
        pm20000.doctype,
        pm20000.docdate,
        pm20000.pstgdate,
        pm20000.duedate,
        'Open' as doc_status,
        pm20000.curtrxam,
        pm20000.trxdscrn,
        pm20000.dinvpdof,
        pm20000.vchrnmbr,
        pm20000.vendorid,
        pm20000.trxsorce
    from pm20000
    where pm20000.voided = 0

    union all

    select
        pm30200.curncyid,
        pm30200.docnumbr,
        pm30200.doctype,
        pm30200.docdate,
        pm30200.pstgdate,
        pm30200.duedate,
        'Historical' as doc_status,
        pm30200.curtrxam,
        pm30200.trxdscrn,
        pm30200.dinvpdof,
        pm30200.vchrnmbr,
        pm30200.vendorid,
        pm30200.trxsorce
    from pm30200
    where pm30200.voided = 0
),

dist_lines as (
    select
        pm10100.vchrnmbr,
        pm10100.vendorid,
        pm10100.dstindx,
        pm10100.disttype,
        pm10100.trxsorce,
        pm10100.debitamt,
        pm10100.crdtamnt,
        pm10100.ordbtamt,
        pm10100.orcrdamt,
        pm10100.distref,
        null::float as xchgrate
    from pm10100

    union all

    select
        pm30600.vchrnmbr,
        pm30600.vendorid,
        pm30600.dstindx,
        pm30600.disttype,
        pm30600.trxsorce,
        pm30600.debitamt,
        pm30600.crdtamnt,
        pm30600.ordbtamt,
        pm30600.orcrdamt,
        pm30600.distref,
        mc020103.xchgrate
    from pm30600
    left join {{ ref('stg_gp_cpqln__mc020103') }} as mc020103
        on pm30600.vchrnmbr = mc020103.vchrnmbr
            and pm30600.doctype = mc020103.doctype
),

cpqln_ap_transactions as (
    select
        4 as series,
        pm00200.vendorid as vendor_id,
        pm00200.vendname as vendor_name,
        pm00200.vndclsid as vendor_class,
        pm00200.pymntpri as payment_priority,
        pm00200.userdef1 as vendor_type,

        doc_headers.docnumbr as document_number,
        doc_headers.doctype as document_type,
        doc_headers.docdate as document_date,
        doc_headers.pstgdate as posting_date,
        doc_headers.duedate as due_date,

        gl00100.actnumbr_1 as account_number,
        gl00100.actdescr as account_description,

        dist_lines.disttype as distribution_type,
        dist_lines.distref as reference,
        doc_headers.doc_status as transaction_status,
        doc_headers.dinvpdof as paid_off_date,
        doc_headers.curtrxam as current_transaction_amount,

        company_cpqln.company_name,

        case
            when coalesce(extender.paid_in_usd, 0) = 1 then 'USD'
            else doc_headers.curncyid
        end as curncyid,

        case
            when upper(ltrim(rtrim(doc_headers.curncyid))) != upper(mc40000.functional_currency)
                and coalesce(extender.paid_in_usd, 0) < 1
                then dist_lines.ordbtamt
            else dist_lines.debitamt
        end as originating_debit_amount,

        case
            when upper(ltrim(rtrim(doc_headers.curncyid))) != upper(mc40000.functional_currency)
                and coalesce(extender.paid_in_usd, 0) < 1
                then dist_lines.orcrdamt
            else dist_lines.crdtamnt
        end as originating_credit_amount

    from doc_headers
    left join dist_lines
        on ltrim(rtrim(doc_headers.vchrnmbr)) = ltrim(rtrim(dist_lines.vchrnmbr))
            and ltrim(rtrim(doc_headers.vendorid)) = ltrim(rtrim(dist_lines.vendorid))
            and doc_headers.trxsorce = dist_lines.trxsorce
    left join pm00200
        on ltrim(rtrim(doc_headers.vendorid)) = ltrim(rtrim(pm00200.vendorid))
    left join gl00100
        on ltrim(rtrim(dist_lines.dstindx)) = ltrim(rtrim(gl00100.actindx))
    left join extender
        on trim(dist_lines.vendorid) = trim(extender.vendorid)
    cross join company_cpqln
    cross join mc40000
    where doc_headers.pstgdate >= '{{ var("gp_cff_pstgdate") }}'
)

select *
from cpqln_ap_transactions
