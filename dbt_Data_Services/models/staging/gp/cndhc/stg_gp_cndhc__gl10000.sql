with source as (

    select * from {{ source('cndhc_dbo', 'gl10000') }}

),

renamed as (

    select
        user_defined_text02,
        dex_row_ts,
        noteindx,
        glhdrms2,
        mctrxstt,
        sqncline,
        series,
        dtatrxtype,
        errstate,
        icdists,
        openyear,
        time1,
        balfrclc,
        dtacontrolnum,
        rvrsngdt,
        ortrxsrc,
        bchsourc,
        rvtrxsrc,
        original_je,
        dex_row_id,
        original_je_year,
        pstgstus,
        correcting_trx_type,
        trxsorce,
        ledger_id,
        refrence,
        lastuser,
        closedyr,
        revclyr,
        tax_date,
        jrnentry,
        user_defined_text01,
        originje,
        sourcdoc,
        rtclcmtd,
        trxdate,
        orpstddt,
        exchdate,
        prntstus,
        rcrngtrx,
        voided,
        periodid,
        denxrate,
        glhdrmsg,
        uswhpstd,
        adjustment_transaction,
        ratetpid,
        revhist,
        trxtype,
        ictrx,
        docdate,
        origdtaseries,
        curncyid,
        orcomid,
        lstdtedt,
        original_je_seq_num,
        exgtblid,
        dta_index,
        glhdrval,
        histrx,
        rctrxseq,
        currnidx,
        bachnumb,
        revprdid,
        xchgrate,
        revyear,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
