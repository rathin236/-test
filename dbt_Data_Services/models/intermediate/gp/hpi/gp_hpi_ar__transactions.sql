with company as (
    select * from {{ ref('stg_gp__company_name') }}
),

mc40000 as (
    select ltrim(rtrim(funlcurr)) from {{ ref('stg_gp_hpi__mc40000') }}
),

rm20101 as (
    select * from {{ ref('stg_gp_hpi__rm20101') }}
),

rm30101 as (
    select * from {{ ref('stg_gp_hpi__rm30101') }}
),

rm10101 as (
    select * from {{ ref('stg_gp_hpi__rm10101') }}
),

rm30301 as (
    select * from {{ ref('stg_gp_hpi__rm30301') }}
),

rm00101 as (
    select * from {{ ref('stg_gp_hpi__rm00101') }}
),

gl00100 as (
    select * from {{ ref('stg_gp_hpi__gl00100') }}
),

hpi_ar_transactions as (

    select
        '3' as series,--noqa
        cmt.custnmbr as customer_id,
        cmt.custname as customer_name,
        cmt.custclas as customer_class,
        dht.curncyid as currency_id,
        cmt.custpriority as payment_priority,
        cmt.userdef1 as customer_type,
        dht.docnumbr as document_number,
        dht.rmdtypal as document_type,
        dht.docdate as document_date,
        dht.postdate as posting_date,
        dht.duedate as invoice_due_date,
        amd.actnumbr_1 as account_number,
        amd.actdescr as account_name,
        ddt.disttype as distribution_type,
        ddt.distref as distribution_reference,
        ddt.distref as reference,
        dht.status,
        dht.dinvpdof as paid_off_date,
        dht.curtrxam as current_transaction_amount,
        (select company_name from company
where ltrim(rtrim(interid)) = 'HPI') as company_name,
        case
            when ltrim(rtrim(dht.curncyid)) != (select * from mc40000) then ddt.ordbtamt--noqa
            else ddt.debitamt
        end as originating_debit_amount,
        case
            when ltrim(rtrim(dht.curncyid)) != (select * from mc40000) then ddt.orcrdamt--noqa
            else ddt.crdtamnt
        end as originating_credit_amount
    from
        (
            select
                custnmbr,
                docnumbr,
                trxsorce,
                duedate,
                docdate,
                postdate,
                curtrxam,
                trxdscrn,
                dinvpdof,
                curncyid,
                rmdtypal,
                'Open' as status,
                glpostdt
            from rm20101
            where voidstts = 0
            union all
            select
                custnmbr,
                docnumbr,
                trxsorce,
                duedate,
                docdate,
                postdate,
                curtrxam,
                trxdscrn,
                dinvpdof,
                curncyid,
                rmdtypal,
                'History' as status,
                glpostdt
            from rm30101
            where voidstts = 0
        ) as dht
    left outer join
        ( --noqa
            select
                trxsorce,
                docnumbr,
                disttype,
                rmdtypal,
                custnmbr,
                dstindx,
                debitamt,
                crdtamnt,
                curncyid,
                orcrdamt,
                ordbtamt,
                distref
            from rm10101
            union all
            select
                trxsorce,
                docnumbr,
                disttype,
                rmdtypal,
                custnmbr,
                dstindx,
                debitamt,
                crdtamnt,
                curncyid,
                orcrdamt,
                ordbtamt,
                distref
            from rm30301

        ) as ddt
        on dht.trxsorce = ddt.trxsorce
            and ltrim(rtrim(dht.rmdtypal)) = ltrim(rtrim(ddt.rmdtypal))
            and ltrim(rtrim(dht.custnmbr)) = ltrim(rtrim(ddt.custnmbr))
            and ltrim(rtrim(dht.docnumbr)) = ltrim(rtrim(ddt.docnumbr))
    left outer join rm00101 as cmt
        on ltrim(rtrim(ddt.custnmbr)) = ltrim(rtrim(cmt.custnmbr))
    left outer join gl00100 as amd
        on ltrim(rtrim(ddt.dstindx)) = ltrim(rtrim(amd.actindx))
    where dht.glpostdt >= '{{ var("gp_cff_pstgdate") }}'

)

select * from hpi_ar_transactions
