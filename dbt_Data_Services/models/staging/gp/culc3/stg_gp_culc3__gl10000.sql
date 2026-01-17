with source as (

    select * from {{ source('culc3_dbo', 'gl10000') }}

),

renamed as (

    select
        origdtaseries,
        rvrsngdt,
        rcrngtrx,
        trxtype,
        dtacontrolnum,
        time1,
        bchsourc,
        original_je_year,
        dex_row_ts,
        revclyr,
        mctrxstt,
        trxdate,
        histrx,
        user_defined_text02,
        orpstddt,
        voided,
        bachnumb,
        balfrclc,
        openyear,
        ortrxsrc,
        curncyid,
        refrence,
        rvtrxsrc,
        series,
        dta_index,
        originje,
        denxrate,
        adjustment_transaction,
        exgtblid,
        pstgstus,
        dtatrxtype,
        correcting_trx_type,
        orcomid,
        jrnentry,
        rtclcmtd,
        dex_row_id,
        xchgrate,
        tax_date,
        rctrxseq,
        ledger_id,
        glhdrval,
        closedyr,
        original_je,
        periodid,
        docdate,
        original_je_seq_num,
        noteindx,
        glhdrmsg,
        lastuser,
        icdists,
        exchdate,
        ictrx,
        user_defined_text01,
        uswhpstd,
        glhdrms2,
        revyear,
        errstate,
        prntstus,
        revprdid,
        sqncline,
        ratetpid,
        revhist,
        sourcdoc,
        trxsorce,
        lstdtedt,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
