with source as (

    select * from {{ source('cgdvc_dbo', 'gl10000') }}

),

renamed as (

    select
        mctrxstt,
        tax_date,
        ictrx,
        noteindx,
        dtatrxtype,
        balfrclc,
        series,
        openyear,
        sqncline,
        uswhpstd,
        origdtaseries,
        histrx,
        rctrxseq,
        trxsorce,
        exchdate,
        original_je_year,
        orcomid,
        rcrngtrx,
        revclyr,
        jrnentry,
        curncyid,
        originje,
        icdists,
        voided,
        ratetpid,
        closedyr,
        dex_row_id,
        docdate,
        bachnumb,
        lstdtedt,
        rtclcmtd,
        pstgstus,
        correcting_trx_type,
        adjustment_transaction,
        dtacontrolnum,
        time1,
        periodid,
        currnidx,
        original_je,
        prntstus,
        user_defined_text02,
        glhdrms2,
        bchsourc,
        denxrate,
        ortrxsrc,
        dex_row_ts,
        ledger_id,
        errstate,
        exgtblid,
        rvrsngdt,
        refrence,
        trxtype,
        user_defined_text01,
        xchgrate,
        trxdate,
        sourcdoc,
        rvtrxsrc,
        glhdrval,
        revyear,
        original_je_seq_num,
        orpstddt,
        dta_index,
        revprdid,
        glhdrmsg,
        lastuser,
        revhist,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
