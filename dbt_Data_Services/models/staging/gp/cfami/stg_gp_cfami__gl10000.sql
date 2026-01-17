with source as (

    select * from {{ source('cfami_dbo', 'gl10000') }}

),

renamed as (

    select
        series,
        rtclcmtd,
        lstdtedt,
        noteindx,
        openyear,
        dex_row_id,
        trxsorce,
        prntstus,
        exgtblid,
        originje,
        glhdrms2,
        ledger_id,
        user_defined_text02,
        xchgrate,
        balfrclc,
        exchdate,
        ortrxsrc,
        tax_date,
        time1,
        dex_row_ts,
        histrx,
        icdists,
        trxdate,
        original_je_seq_num,
        curncyid,
        orpstddt,
        rcrngtrx,
        denxrate,
        bchsourc,
        dtacontrolnum,
        periodid,
        closedyr,
        correcting_trx_type,
        jrnentry,
        adjustment_transaction,
        uswhpstd,
        pstgstus,
        errstate,
        bachnumb,
        docdate,
        ictrx,
        revhist,
        sqncline,
        orcomid,
        refrence,
        revprdid,
        glhdrmsg,
        dta_index,
        rvtrxsrc,
        sourcdoc,
        rctrxseq,
        rvrsngdt,
        trxtype,
        revyear,
        mctrxstt,
        original_je,
        voided,
        ratetpid,
        glhdrval,
        dtatrxtype,
        user_defined_text01,
        lastuser,
        original_je_year,
        revclyr,
        currnidx,
        origdtaseries,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
