with ap_invoices as (

    select * from {{ ref('stg_sage_100_roy__ap_invoicehistoryheader') }}

),

ap_payments as (

    select * from {{ ref('int_sage_100_roy__ap_payments') }}

),

ar_invoices as (

    select * from {{ ref('stg_sage_100_roy__ar_invoicehistoryheader') }}

),

account_master as (

    select * from {{ ref('int_sage_100_roy__account_master') }}

),

gl_details as (

    select * from {{ ref('stg_sage_100_roy__gl_detailposting') }}

),

joined as (

    select

        ama.companycode,
        gld.postingdate,
        gld.sourcejournal,
        gld.journalregisterno,
        ama.account,
        ama.mainaccountcode,
        ama.segment_02,
        ama.segment_03,
        ama.accountdesc,
        ama.segment_02_desc,
        ama.segment_03_desc,
        gld.debitamount,
        gld.creditamount,
        gld.postingcomment,
        ari.invoiceno as arinvoiceno,
        apc.checkno,
        apin.invoiceno as apinvoiceno,
        ari.customerno,
        apc.vendorno as checkvendorno,
        apin.vendorno,
        ari.billtoname,
        apc.vendorname as checkvendorname,
        apin.vendorname

    from gl_details as gld
    left outer join account_master as ama
        on gld.accountkey = ama.accountkey
    left outer join ar_invoices as ari
        on gld.sourcejournal = ari.sourcejournal
        and gld.documentno = ari.invoiceno
        and gld.journalregisterno = ari.journalnoglbatchno
    left join ap_invoices as apin
        on gld.sourcejournal = apin.sourcejournal
        and gld.documentno = apin.invoiceno
        and gld.journalregisterno = apin.sourcejournalno
        and gld.postingdate = apin.transactiondate
        and right(gld.docsequenceno, 6) = apin.headerseqno
    left join ap_payments as apc
        on gld.sourcejournal = apc.sourcejournal
        and gld.journalregisterno = apc.sourcejournalbatchno
        and (gld.debitamount + gld.creditamount) = apc.checkamt
        and (
                gld.documentno = apc.documentno
                or (
                        right(gld.postingcomment, 6) = apc.checkno
                        and gld.accountkey = apc.cashaccountkey
                        and gld.documentno is null
                )
            )
),

transformed as (

    select

        companycode as company,
        account as account_number,
        mainaccountcode as main_account_number,
        segment_02 as sub_account,
        segment_03 as detail,
        accountdesc as account_description,
        segment_02_desc as sub_account_description,
        segment_03_desc as detail_description,
        debitamount,
        creditamount,
        postingcomment,
        date(postingdate) as transaction_date,
        month(postingdate) as period,
        concat(sourcejournal, '-', journalregisterno) as journal_entry_number,
        coalesce(arinvoiceno, checkno, apinvoiceno) as originating_document_number,
        coalesce(customerno, checkvendorno, vendorno) as originating_id,
        coalesce(billtoname, checkvendorname, vendorname) as originating_name

    from joined

)

select * from transformed
