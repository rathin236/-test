with company as (
    select * from {{ ref('stg_gp__company_name') }}
),

mc40000 as (
    select ltrim(rtrim(funlcurr)) from {{ ref('stg_gp_cap__mc40000') }}
),

pm20000 as (
    select * from {{ ref('stg_gp_cap__pm20000') }}
),

pm30200 as (
    select * from {{ ref('stg_gp_cap__pm30200') }}
),

pm10100 as (
    select * from {{ ref('stg_gp_cap__pm10100') }}
),

pm30600 as (
    select * from {{ ref('stg_gp_cap__pm30600') }}
),

pm00200 as (
    select * from {{ ref('stg_gp_cap__pm00200') }}
),

gl00100 as (
    select * from {{ ref('stg_gp_cap__gl00100') }}
),

cap_ap_transactions as (

    select
        4 as series,
        vmt.vendorid as vendor_id,
        vmt.vendname as vendor_name,
        vmt.vndclsid as vendor_class,
        dht.curncyid as currency_id,
        vmt.pymntpri as payment_priority,
        vmt.userdef1 as vendor_type,
        dht.docnumbr as document_number,
        dht.doctype as document_type,
        dht.docdate as document_date,
        dht.pstgdate as posting_date,
        dht.duedate as due_date,
        actnumbr_1 as account_number,
        actdescr as account_description,
        ddt.disttype as distribution_type,
        ddt.distref as reference,
        dht.status,
        dht.dinvpdof as paid_off_date,
        dht.curtrxam as current_transaction_amount,
        (select company_name from company
where ltrim(rtrim(interid)) = 'CAP') as company_name,
        case
            when ltrim(rtrim(dht.curncyid)) != (select * from mc40000) then ddt.ordbtamt
            else ddt.debitamt
        end as originating_debit_amount,
        case
            when ltrim(rtrim(dht.curncyid)) != (select * from mc40000) then ddt.orcrdamt
            else ddt.crdtamnt
        end as originating_credit_amount
    from
        ( --noqa
            select
                curncyid,
                docnumbr,
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
        ) as dht
    left outer join
        ( --noqa
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
                distref
            from pm10100
            union all
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
                distref
            from pm30600
        ) as ddt
        on ltrim(rtrim(dht.vchrnmbr)) = ltrim(rtrim(ddt.vchrnmbr))
            and ltrim(rtrim(dht.vendorid)) = ltrim(rtrim(ddt.vendorid))
            and dht.trxsorce = ddt.trxsorce
    left outer join pm00200 as vmt
        on ltrim(rtrim(dht.vendorid)) = ltrim(rtrim(vmt.vendorid))
    left outer join gl00100 as amd
        on ltrim(rtrim(ddt.dstindx)) = ltrim(rtrim(amd.actindx))
    where dht.pstgdate >= '{{ var("gp_cff_pstgdate") }}'

)

select * from cap_ap_transactions
