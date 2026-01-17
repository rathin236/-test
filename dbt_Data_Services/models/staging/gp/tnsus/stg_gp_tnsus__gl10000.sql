with source as (

    select * from {{ source('tnsus_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        revyear,
        sourcdoc,
        refrence,
        curncyid,
        revhist,
        lstdtedt,
        tax_date,
        exchdate,
        revclyr,
        user_defined_text02,
        dtacontrolnum,
        currnidx,
        origdtaseries,
        docdate,
        rvtrxsrc,
        ortrxsrc,
        dta_index,
        xchgrate,
        rctrxseq,
        originje,
        denxrate,
        rtclcmtd,
        pstgstus,
        glhdrms2,
        correcting_trx_type,
        mctrxstt,
        rvrsngdt,
        dex_row_ts,
        dex_row_id,
        closedyr,
        time1,
        revprdid,
        ictrx,
        orcomid,
        adjustment_transaction,
        glhdrval,
        histrx,
        errstate,
        noteindx,
        exgtblid,
        uswhpstd,
        series,
        dtatrxtype,
        ratetpid,
        openyear,
        original_je,
        orpstddt,
        original_je_seq_num,
        trxdate,
        sqncline,
        ledger_id,
        rcrngtrx,
        original_je_year,
        periodid,
        icdists,
        glhdrmsg,
        trxsorce,
        trxtype,
        prntstus,
        lastuser,
        balfrclc,
        voided,
        user_defined_text01,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
