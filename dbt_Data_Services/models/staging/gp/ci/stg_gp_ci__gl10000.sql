with source as (

    select * from {{ source('ci_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        glhdrms2,
        curncyid,
        periodid,
        original_je_seq_num,
        rvrsngdt,
        adjustment_transaction,
        closedyr,
        correcting_trx_type,
        ictrx,
        denxrate,
        revhist,
        pstgstus,
        dtacontrolnum,
        dex_row_id,
        revprdid,
        originje,
        lstdtedt,
        uswhpstd,
        voided,
        dtatrxtype,
        trxtype,
        orcomid,
        sqncline,
        revyear,
        mctrxstt,
        refrence,
        dta_index,
        original_je_year,
        revclyr,
        rvtrxsrc,
        tax_date,
        exchdate,
        currnidx,
        time1,
        rctrxseq,
        dex_row_ts,
        series,
        origdtaseries,
        sourcdoc,
        user_defined_text01,
        rtclcmtd,
        lastuser,
        glhdrmsg,
        trxdate,
        ratetpid,
        openyear,
        prntstus,
        orpstddt,
        ledger_id,
        glhdrval,
        errstate,
        trxsorce,
        noteindx,
        histrx,
        balfrclc,
        icdists,
        exgtblid,
        user_defined_text02,
        docdate,
        rcrngtrx,
        ortrxsrc,
        xchgrate,
        original_je,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
