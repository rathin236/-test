with source as (

    select * from {{ source('casl_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        docdate,
        adjustment_transaction,
        lstdtedt,
        histrx,
        tax_date,
        periodid,
        sourcdoc,
        glhdrmsg,
        glhdrval,
        refrence,
        trxsorce,
        prntstus,
        curncyid,
        ictrx,
        currnidx,
        rcrngtrx,
        lastuser,
        revyear,
        sqncline,
        pstgstus,
        correcting_trx_type,
        errstate,
        closedyr,
        origdtaseries,
        dex_row_ts,
        revhist,
        original_je,
        uswhpstd,
        series,
        orpstddt,
        openyear,
        exgtblid,
        orcomid,
        ratetpid,
        dex_row_id,
        time1,
        revprdid,
        mctrxstt,
        dtatrxtype,
        rtclcmtd,
        rvrsngdt,
        denxrate,
        icdists,
        user_defined_text01,
        originje,
        trxdate,
        glhdrms2,
        xchgrate,
        ledger_id,
        user_defined_text02,
        exchdate,
        voided,
        original_je_year,
        dtacontrolnum,
        dta_index,
        revclyr,
        rctrxseq,
        trxtype,
        ortrxsrc,
        balfrclc,
        noteindx,
        original_je_seq_num,
        rvtrxsrc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
