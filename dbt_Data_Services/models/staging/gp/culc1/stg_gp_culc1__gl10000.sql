with source as (

    select * from {{ source('culc1_dbo', 'gl10000') }}

),

renamed as (

    select
        lastuser,
        openyear,
        jrnentry,
        trxsorce,
        exchdate,
        errstate,
        rvtrxsrc,
        sourcdoc,
        rcrngtrx,
        curncyid,
        dtatrxtype,
        series,
        adjustment_transaction,
        origdtaseries,
        lstdtedt,
        ledger_id,
        bachnumb,
        glhdrval,
        xchgrate,
        denxrate,
        icdists,
        balfrclc,
        uswhpstd,
        dta_index,
        currnidx,
        bchsourc,
        periodid,
        glhdrms2,
        rctrxseq,
        prntstus,
        docdate,
        revprdid,
        voided,
        trxtype,
        revyear,
        trxdate,
        dex_row_ts,
        originje,
        ratetpid,
        revclyr,
        noteindx,
        orcomid,
        rvrsngdt,
        original_je_year,
        dex_row_id,
        exgtblid,
        original_je_seq_num,
        closedyr,
        glhdrmsg,
        histrx,
        time1,
        tax_date,
        original_je,
        user_defined_text02,
        ortrxsrc,
        rtclcmtd,
        user_defined_text01,
        dtacontrolnum,
        refrence,
        pstgstus,
        correcting_trx_type,
        revhist,
        sqncline,
        orpstddt,
        ictrx,
        mctrxstt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
