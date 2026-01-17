with company as (
    select * from {{ ref('stg_gp__company_name') }}
),

mc40000 as (
    select ltrim(rtrim(funlcurr)) from {{ ref('stg_gp_tfc__mc40000') }}
),

pm20000 as (
    select * from {{ ref('stg_gp_tfc__pm20000') }}
),

pm30200 as (
    select * from {{ ref('stg_gp_tfc__pm30200') }}
),

pm10100 as (
    select * from {{ ref('stg_gp_tfc__pm10100') }}
),

pm30600 as (
    select * from {{ ref('stg_gp_tfc__pm30600') }}
),

pm00200 as (
    select * from {{ ref('stg_gp_tfc__pm00200') }}
),

gl00100 as (
    select * from {{ ref('stg_gp_tfc__gl00100') }}
),

po_transactions as ( --po_transactions
    select
        curncyid,
        docnumbr,
        pordnmbr,
        doctype,
        docdate,
        pstgdate,
        duedate,
        'Open' as status,
        curtrxam,
        trxdscrn,
        dinvpdof,
        vchrnmbr,
        vendorid,
        trxsorce
    from pm20000
    where voided = 0
    union all
    select
        curncyid,
        docnumbr,
        pordnmbr,
        doctype,
        docdate,
        pstgdate,
        duedate,
        'Historical' as status,
        curtrxam,
        trxdscrn,
        dinvpdof,
        vchrnmbr,
        vendorid,
        trxsorce
    from pm30200
    where voided = 0
),

gl_distributions as (-- gl_distributions
    select
        vchrnmbr,
        vendorid,
        dstindx,
        disttype,
        trxsorce,
        debitamt,
        crdtamnt,
        ordbtamt,
        orcrdamt,
        distref,
        xchgrate
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
        null as xchgrate
        -- mc020103.xchgrate -- adding the exchange rate column
    from pm30600 -- gl_distributions historic transactions
    -- left outer join mc020103 --Multicurrency Payables Transactions
-- on pm30600.vchrnmbr = mc020103.vchrnmbr
--     and pm30600.doctype = mc020103.doctype
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
    left outer join gl_distributions
        on ltrim(rtrim(po_transactions.vchrnmbr)) = ltrim(rtrim(gl_distributions.vchrnmbr))
            and ltrim(rtrim(vendor_id)) = ltrim(rtrim(gl_distributions.vendorid))
            and po_transactions.trxsorce = gl_distributions.trxsorce
    left outer join pm00200
        on ltrim(rtrim(vendor_id)) = ltrim(rtrim(pm00200.vendorid))
    left outer join gl00100
        on ltrim(rtrim(gl_distributions.dstindx)) = ltrim(rtrim(gl00100.actindx))
),

tfc_ap_transactions as (

    select
        'TFC' as company,
        4 as series,
        vendor_id,
        vendname as vendor_name,
        vndclsid as vendor_class,
        curncyid as currency_id,
        pymntpri as payment_priority,
        userdef1 as vendor_type,
        docnumbr as document_number,
        docdate as document_date,
        pstgdate as posting_date,
        duedate as due_date,
        actnumbr_1 as account_number,
        actdescr as account_description,
        distref as reference,
        trxdscrn as transaction_description,
        status as transaction_status,
        dinvpdof as paid_off_date,
        curtrxam as current_transaction_amount,
        debitamt,
        crdtamnt,
        xchgrate,
        trim(pordnmbr) as po_number,
        case doctype
            when 1 then 'Invoice'
            when 2 then 'Finance Charge'
            when 3 then 'Misc Charge'
            when 4 then 'Return'
            when 5 then 'Credit Memo'
            when 6 then 'Payment'
        end as document_type,
        case disttype
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
        (select company_name from company
where ltrim(rtrim(interid)) = 'TFC') as company_name,

        case
            when ltrim(rtrim(curncyid)) != (select * from mc40000) then ordbtamt
            else debitamt
        end as originating_debit_amount,
        case
            when ltrim(rtrim(curncyid)) != (select * from mc40000) then orcrdamt
            else crdtamnt
        end as originating_credit_amount,
        case
            when ltrim(rtrim(curncyid)) = 'USD' then ordbtamt
            else debitamt / 1.35
        end as usd_debit,
        case
            when ltrim(rtrim(curncyid)) = 'USD' then orcrdamt
            else crdtamnt / 1.35
        end as usd_credit,
        -- case 
        --     when ltrim(rtrim(curncyid)) != 'USD' then current_transaction_amount * 1.35
        --     else current_transaction_amount
        -- end as usd_transaction_amount,
        company || vendor_id as vendor_key,
        po_number || company || vendor_id as po_key
    from
        all_transactions
)

select * from tfc_ap_transactions
-- where trim(currency_id) = 'Z-EURO'
