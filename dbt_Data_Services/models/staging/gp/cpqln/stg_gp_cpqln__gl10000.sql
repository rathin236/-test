with source as (

    select * from {{ source('cpqln_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        dex_row_ts,
        originje,
        revprdid,
        trxdate,
        exgtblid,
        correcting_trx_type,
        user_defined_text02,
        dta_index,
        time1,
        rvrsngdt,
        xchgrate,
        closedyr,
        original_je,
        ratetpid,
        dtacontrolnum,
        currnidx,
        uswhpstd,
        user_defined_text01,
        ictrx,
        revhist,
        docdate,
        errstate,
        histrx,
        denxrate,
        trxsorce,
        origdtaseries,
        lstdtedt,
        glhdrms2,
        sourcdoc,
        rcrngtrx,
        exchdate,
        lastuser,
        revclyr,
        revyear,
        pstgstus,
        original_je_year,
        sqncline,
        trxtype,
        prntstus,
        refrence,
        rvtrxsrc,
        periodid,
        rctrxseq,
        balfrclc,
        glhdrval,
        rtclcmtd,
        dtatrxtype,
        mctrxstt,
        ortrxsrc,
        orpstddt,
        orcomid,
        glhdrmsg,
        series,
        ledger_id,
        adjustment_transaction,
        tax_date,
        openyear,
        curncyid,
        original_je_seq_num,
        voided,
        icdists,
        noteindx,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
