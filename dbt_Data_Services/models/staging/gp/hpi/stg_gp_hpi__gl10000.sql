with source as (

    select * from {{ source('hpi_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        trxtype,
        denxrate,
        pstgstus,
        original_je_year,
        dtacontrolnum,
        rvrsngdt,
        orpstddt,
        dta_index,
        user_defined_text02,
        time1,
        dtatrxtype,
        adjustment_transaction,
        glhdrmsg,
        ictrx,
        origdtaseries,
        revclyr,
        original_je_seq_num,
        trxsorce,
        originje,
        icdists,
        ratetpid,
        revyear,
        dex_row_ts,
        rcrngtrx,
        dex_row_id,
        sourcdoc,
        balfrclc,
        docdate,
        revprdid,
        xchgrate,
        uswhpstd,
        periodid,
        glhdrval,
        prntstus,
        rctrxseq,
        tax_date,
        lstdtedt,
        correcting_trx_type,
        original_je,
        ledger_id,
        sqncline,
        revhist,
        voided,
        currnidx,
        errstate,
        user_defined_text01,
        noteindx,
        glhdrms2,
        openyear,
        series,
        lastuser,
        exgtblid,
        trxdate,
        refrence,
        curncyid,
        histrx,
        rtclcmtd,
        rvtrxsrc,
        ortrxsrc,
        orcomid,
        closedyr,
        exchdate,
        mctrxstt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
