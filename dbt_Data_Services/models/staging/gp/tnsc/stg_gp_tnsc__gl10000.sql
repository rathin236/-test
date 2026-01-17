with source as (

    select * from {{ source('tnsc_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        sqncline,
        periodid,
        prntstus,
        rctrxseq,
        trxsorce,
        currnidx,
        lastuser,
        refrence,
        curncyid,
        icdists,
        orpstddt,
        noteindx,
        trxdate,
        sourcdoc,
        ledger_id,
        revclyr,
        correcting_trx_type,
        user_defined_text02,
        pstgstus,
        errstate,
        ictrx,
        exchdate,
        original_je,
        closedyr,
        revhist,
        time1,
        dtacontrolnum,
        ortrxsrc,
        mctrxstt,
        rvtrxsrc,
        dta_index,
        glhdrval,
        rcrngtrx,
        glhdrmsg,
        dex_row_id,
        denxrate,
        voided,
        xchgrate,
        tax_date,
        rtclcmtd,
        orcomid,
        balfrclc,
        exgtblid,
        originje,
        origdtaseries,
        histrx,
        lstdtedt,
        dtatrxtype,
        docdate,
        openyear,
        series,
        user_defined_text01,
        original_je_seq_num,
        original_je_year,
        glhdrms2,
        revprdid,
        revyear,
        uswhpstd,
        ratetpid,
        trxtype,
        adjustment_transaction,
        rvrsngdt,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
