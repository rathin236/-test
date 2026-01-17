with source as (

    select * from {{ source('wvcl_dbo', 'gl10000') }}

),

renamed as (

    select
        rvrsngdt,
        noteindx,
        rctrxseq,
        jrnentry,
        rtclcmtd,
        icdists,
        lastuser,
        revprdid,
        balfrclc,
        time1,
        original_je_seq_num,
        mctrxstt,
        dex_row_ts,
        user_defined_text01,
        sourcdoc,
        voided,
        original_je_year,
        ledger_id,
        pstgstus,
        correcting_trx_type,
        glhdrmsg,
        ratetpid,
        trxsorce,
        dtatrxtype,
        lstdtedt,
        docdate,
        sqncline,
        revclyr,
        openyear,
        uswhpstd,
        series,
        bchsourc,
        dtacontrolnum,
        originje,
        adjustment_transaction,
        revyear,
        glhdrms2,
        tax_date,
        user_defined_text02,
        exchdate,
        ictrx,
        dex_row_id,
        dta_index,
        rcrngtrx,
        closedyr,
        histrx,
        bachnumb,
        prntstus,
        periodid,
        trxtype,
        rvtrxsrc,
        original_je,
        orcomid,
        curncyid,
        glhdrval,
        refrence,
        trxdate,
        xchgrate,
        errstate,
        exgtblid,
        orpstddt,
        currnidx,
        revhist,
        ortrxsrc,
        denxrate,
        origdtaseries,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
