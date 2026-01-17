with source as (

    select * from {{ source('gmg_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        uswhpstd,
        dex_row_ts,
        histrx,
        origdtaseries,
        user_defined_text01,
        revclyr,
        rvrsngdt,
        time1,
        original_je_year,
        lastuser,
        dtatrxtype,
        rtclcmtd,
        exgtblid,
        closedyr,
        original_je,
        noteindx,
        glhdrmsg,
        refrence,
        orpstddt,
        dtacontrolnum,
        orcomid,
        user_defined_text02,
        trxdate,
        mctrxstt,
        pstgstus,
        correcting_trx_type,
        sqncline,
        errstate,
        ictrx,
        rvtrxsrc,
        ortrxsrc,
        revhist,
        originje,
        original_je_seq_num,
        dex_row_id,
        lstdtedt,
        tax_date,
        exchdate,
        curncyid,
        glhdrval,
        series,
        openyear,
        dta_index,
        sourcdoc,
        ledger_id,
        rcrngtrx,
        trxsorce,
        icdists,
        rctrxseq,
        currnidx,
        balfrclc,
        xchgrate,
        adjustment_transaction,
        ratetpid,
        docdate,
        trxtype,
        voided,
        periodid,
        prntstus,
        glhdrms2,
        revyear,
        denxrate,
        revprdid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
