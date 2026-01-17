with company as (
    select *
    from {{ ref('stg_gp__company_name') }}
),

mc40000 as (
    select ltrim(rtrim(funlcurr)) as functional_currency
    from {{ ref('stg_gp_cpqln__mc40000') }}
),

mc020103 as (
    select *
    from {{ ref('stg_gp_cpqln__mc020103') }}
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

po_transactions as (
    select
        pm20000.curncyid,
        pm20000.docnumbr,
        pm20000.pordnmbr,
        pm20000.doctype,
        pm20000.docdate,
        pm20000.pstgdate,
        pm20000.duedate,
        'Open' as status,
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
        pm30200.pordnmbr,
        pm30200.doctype,
        pm30200.docdate,
        pm30200.pstgdate,
        pm30200.duedate,
        'Historical' as status,
        pm30200.curtrxam,
        pm30200.trxdscrn,
        pm30200.dinvpdof,
        pm30200.vchrnmbr,
        pm30200.vendorid,
        pm30200.trxsorce
    from pm30200
    where pm30200.voided = 0
),

gl_distributions as (
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
        pm10100.xchgrate
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
    left join mc020103
        on pm30600.vchrnmbr = mc020103.vchrnmbr
            and pm30600.doctype = mc020103.doctype
),

all_transactions as (
    select
        po_transactions.curncyid,
        po_transactions.docnumbr,
        po_transactions.pordnmbr,
        po_transactions.doctype,
        po_transactions.docdate,
        po_transactions.pstgdate,
        po_transactions.duedate,
        po_transactions.status,
        po_transactions.curtrxam,
        po_transactions.trxdscrn,
        po_transactions.dinvpdof,
        po_transactions.vchrnmbr,
        po_transactions.vendorid as vendor_id,
        po_transactions.trxsorce,
        gl_distributions.dstindx,
        gl_distributions.disttype,
        gl_distributions.debitamt,
        gl_distributions.crdtamnt,
        gl_distributions.ordbtamt,
        gl_distributions.orcrdamt,
        gl_distributions.xchgrate,
        gl_distributions.distref,
        pm00200.vendname,
        pm00200.vndclsid,
        pm00200.pymntpri,
        pm00200.userdef1,
        gl00100.actnumbr_1,
        gl00100.actdescr
    from po_transactions
    left join gl_distributions
        on ltrim(rtrim(po_transactions.vchrnmbr)) = ltrim(rtrim(gl_distributions.vchrnmbr))
            and ltrim(rtrim(po_transactions.vendorid)) = ltrim(rtrim(gl_distributions.vendorid))
            and po_transactions.trxsorce = gl_distributions.trxsorce
    left join pm00200
        on ltrim(rtrim(po_transactions.vendorid)) = ltrim(rtrim(pm00200.vendorid))
    left join gl00100
        on ltrim(rtrim(gl_distributions.dstindx)) = ltrim(rtrim(gl00100.actindx))
),

cpqln_ap_transactions as (
    select
        'CPQLN' as company,
        4 as series,
        all_transactions.vendor_id,
        all_transactions.vendname as vendor_name,
        all_transactions.vndclsid as vendor_class,
        all_transactions.curncyid as currency_id,
        all_transactions.pymntpri as payment_priority,
        all_transactions.userdef1 as vendor_type,
        all_transactions.docnumbr as document_number,
        all_transactions.docdate as document_date,
        all_transactions.pstgdate as posting_date,
        all_transactions.duedate as due_date,
        all_transactions.actnumbr_1 as account_number,
        all_transactions.actdescr as account_description,
        all_transactions.distref as reference,
        all_transactions.trxdscrn as transaction_description,
        all_transactions.status as transaction_status,
        all_transactions.dinvpdof as paid_off_date,
        all_transactions.curtrxam as current_transaction_amount,
        all_transactions.debitamt,
        all_transactions.crdtamnt,
        all_transactions.xchgrate,
        trim(all_transactions.pordnmbr) as po_number,
        case all_transactions.doctype
            when 1 then 'Invoice'
            when 2 then 'Finance Charge'
            when 3 then 'Misc Charge'
            when 4 then 'Return'
            when 5 then 'Credit Memo'
            when 6 then 'Payment'
        end as document_type,
        case all_transactions.disttype
            when 1 then 'Cash'
            when 2 then 'Payable'
            when 3 then 'Discount Available'
            when 4 then 'Discount Taken'
            when 5 then 'Finance Charge'
            when 6 then 'Purchase'
            when 7 then 'Trade Disc.'
            when 8 then 'Misc. Charge'
            when 9 then 'Freight'
            when 10 then 'Taxes'
            when 11 then 'Writeoffs'
            when 12 then 'Other'
            when 13 then 'GST Disc'
            when 14 then 'PPS Amount'
            when 16 then 'Round'
            when 17 then 'Realized Gain'
            when 18 then 'Relaized Loss'
            when 19 then 'Due To'
            when 20 then 'Due From'
        end as distribution_type,
        (
            select company.company_name
            from company
            where ltrim(rtrim(company.interid)) = 'CPQLN'
        ) as company_name,
        case
            when ltrim(rtrim(all_transactions.curncyid)) != (
                    select mc40000.functional_currency from mc40000
                )
                then all_transactions.ordbtamt
            else all_transactions.debitamt
        end as originating_debit_amount,
        case
            when ltrim(rtrim(all_transactions.curncyid)) != (
                    select mc40000.functional_currency from mc40000
                )
                then all_transactions.orcrdamt
            else all_transactions.crdtamnt
        end as originating_credit_amount,
        case
            when ltrim(rtrim(all_transactions.curncyid)) = 'CLP'
                and all_transactions.status = 'Historical'
                then all_transactions.ordbtamt / nullif(all_transactions.xchgrate, 0)
            when all_transactions.curncyid = 'USD'
                then all_transactions.debitamt
            else all_transactions.debitamt
        end as usd_debit,
        case
            when ltrim(rtrim(all_transactions.curncyid)) = 'CLP'
                and all_transactions.status = 'Historical'
                then all_transactions.orcrdamt / nullif(all_transactions.xchgrate, 0)
            when all_transactions.curncyid = 'USD'
                then all_transactions.crdtamnt
            else all_transactions.crdtamnt
        end as usd_credit,
        'CPQLN' || all_transactions.vendor_id as vendor_key,
        trim(all_transactions.pordnmbr) || 'CPQLN' || all_transactions.vendor_id as po_key
    from all_transactions
)

select *
from cpqln_ap_transactions
