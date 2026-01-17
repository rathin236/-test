with source as (

    select * from {{ source('hsi_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        original_je,
        revyear,
        exchdate,
        rcrngtrx,
        histrx,
        adjustment_transaction,
        lastuser,
        revclyr,
        glhdrmsg,
        trxsorce,
        errstate,
        original_je_year,
        tax_date,
        glhdrms2,
        lstdtedt,
        sourcdoc,
        closedyr,
        docdate,
        uswhpstd,
        rtclcmtd,
        originje,
        dta_index,
        denxrate,
        rctrxseq,
        voided,
        rvrsngdt,
        pstgstus,
        glhdrval,
        correcting_trx_type,
        xchgrate,
        mctrxstt,
        ratetpid,
        dex_row_id,
        icdists,
        dex_row_ts,
        trxdate,
        revprdid,
        exgtblid,
        series,
        dtatrxtype,
        noteindx,
        openyear,
        original_je_seq_num,
        origdtaseries,
        orpstddt,
        ledger_id,
        ortrxsrc,
        curncyid,
        user_defined_text01,
        balfrclc,
        currnidx,
        revhist,
        orcomid,
        sqncline,
        periodid,
        user_defined_text02,
        ictrx,
        time1,
        refrence,
        dtacontrolnum,
        rvtrxsrc,
        trxtype,
        prntstus,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
