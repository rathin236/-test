with source as (

    select * from {{ source('tfci_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        lstdtedt,
        tax_date,
        currnidx,
        errstate,
        user_defined_text01,
        closedyr,
        periodid,
        prntstus,
        exgtblid,
        histrx,
        lastuser,
        pstgstus,
        correcting_trx_type,
        sqncline,
        refrence,
        curncyid,
        orcomid,
        dex_row_ts,
        glhdrval,
        openyear,
        ictrx,
        ledger_id,
        original_je_year,
        revhist,
        docdate,
        ortrxsrc,
        dtacontrolnum,
        revclyr,
        series,
        rvtrxsrc,
        mctrxstt,
        dtatrxtype,
        balfrclc,
        user_defined_text02,
        time1,
        voided,
        original_je_seq_num,
        rtclcmtd,
        glhdrms2,
        sourcdoc,
        rvrsngdt,
        noteindx,
        dex_row_id,
        revprdid,
        rcrngtrx,
        originje,
        trxtype,
        trxsorce,
        xchgrate,
        trxdate,
        dta_index,
        glhdrmsg,
        denxrate,
        revyear,
        icdists,
        rctrxseq,
        exchdate,
        ratetpid,
        adjustment_transaction,
        orpstddt,
        original_je,
        uswhpstd,
        origdtaseries,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
