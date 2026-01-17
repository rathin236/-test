with source as (

    select * from {{ source('gdvii_dbo', 'gl10000') }}

),

renamed as (

    select
        dex_row_ts,
        trxdate,
        pstgstus,
        original_je_year,
        icdists,
        rtclcmtd,
        balfrclc,
        sqncline,
        dtacontrolnum,
        bchsourc,
        ratetpid,
        rctrxseq,
        time1,
        trxtype,
        mctrxstt,
        rvrsngdt,
        user_defined_text02,
        ortrxsrc,
        orpstddt,
        rvtrxsrc,
        orcomid,
        bachnumb,
        glhdrmsg,
        tax_date,
        revyear,
        currnidx,
        exgtblid,
        voided,
        curncyid,
        glhdrval,
        errstate,
        adjustment_transaction,
        origdtaseries,
        rcrngtrx,
        xchgrate,
        exchdate,
        ledger_id,
        correcting_trx_type,
        glhdrms2,
        denxrate,
        original_je,
        lastuser,
        dta_index,
        histrx,
        revprdid,
        dex_row_id,
        periodid,
        refrence,
        closedyr,
        prntstus,
        series,
        ictrx,
        user_defined_text01,
        jrnentry,
        docdate,
        lstdtedt,
        uswhpstd,
        originje,
        dtatrxtype,
        trxsorce,
        revclyr,
        revhist,
        noteindx,
        original_je_seq_num,
        sourcdoc,
        openyear,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
