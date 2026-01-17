with source as (

    select * from {{ source('culc4_dbo', 'gl10000') }}

),

renamed as (

    select
        ratetpid,
        revyear,
        originje,
        sqncline,
        prntstus,
        dex_row_id,
        user_defined_text01,
        exchdate,
        currnidx,
        noteindx,
        trxtype,
        glhdrms2,
        original_je_year,
        orpstddt,
        bchsourc,
        revclyr,
        ledger_id,
        voided,
        periodid,
        uswhpstd,
        balfrclc,
        icdists,
        tax_date,
        rctrxseq,
        xchgrate,
        jrnentry,
        rvrsngdt,
        glhdrval,
        series,
        refrence,
        rcrngtrx,
        openyear,
        curncyid,
        trxsorce,
        denxrate,
        time1,
        rvtrxsrc,
        dta_index,
        sourcdoc,
        trxdate,
        glhdrmsg,
        revprdid,
        errstate,
        bachnumb,
        adjustment_transaction,
        rtclcmtd,
        dex_row_ts,
        dtatrxtype,
        original_je_seq_num,
        lastuser,
        origdtaseries,
        original_je,
        revhist,
        closedyr,
        pstgstus,
        correcting_trx_type,
        user_defined_text02,
        ictrx,
        docdate,
        dtacontrolnum,
        ortrxsrc,
        mctrxstt,
        histrx,
        exgtblid,
        lstdtedt,
        orcomid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
