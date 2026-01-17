with source as (

    select * from {{ source('cstus_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        sourcdoc,
        curncyid,
        refrence,
        revyear,
        ortrxsrc,
        noteindx,
        icdists,
        rvtrxsrc,
        original_je_seq_num,
        rctrxseq,
        lastuser,
        revhist,
        original_je_year,
        user_defined_text02,
        revclyr,
        dex_row_ts,
        rvrsngdt,
        origdtaseries,
        time1,
        dtatrxtype,
        tax_date,
        originje,
        rtclcmtd,
        rcrngtrx,
        glhdrmsg,
        sqncline,
        pstgstus,
        correcting_trx_type,
        trxsorce,
        closedyr,
        trxdate,
        orpstddt,
        mctrxstt,
        dex_row_id,
        histrx,
        user_defined_text01,
        adjustment_transaction,
        revprdid,
        original_je,
        ratetpid,
        uswhpstd,
        exchdate,
        glhdrval,
        ledger_id,
        dta_index,
        voided,
        openyear,
        ictrx,
        series,
        currnidx,
        xchgrate,
        lstdtedt,
        balfrclc,
        glhdrms2,
        errstate,
        dtacontrolnum,
        exgtblid,
        trxtype,
        denxrate,
        docdate,
        orcomid,
        prntstus,
        periodid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
