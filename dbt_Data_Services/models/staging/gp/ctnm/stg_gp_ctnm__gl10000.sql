with source as (

    select * from {{ source('ctnm_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        uswhpstd,
        series,
        mctrxstt,
        denxrate,
        ratetpid,
        docdate,
        balfrclc,
        revprdid,
        orcomid,
        histrx,
        originje,
        trxdate,
        rvrsngdt,
        rcrngtrx,
        trxtype,
        exgtblid,
        tax_date,
        icdists,
        dex_row_ts,
        voided,
        currnidx,
        origdtaseries,
        adjustment_transaction,
        prntstus,
        ortrxsrc,
        noteindx,
        periodid,
        sqncline,
        errstate,
        sourcdoc,
        revyear,
        curncyid,
        user_defined_text02,
        dtacontrolnum,
        exchdate,
        rvtrxsrc,
        glhdrms2,
        closedyr,
        orpstddt,
        glhdrmsg,
        original_je_year,
        revclyr,
        original_je_seq_num,
        dex_row_id,
        trxsorce,
        ledger_id,
        correcting_trx_type,
        pstgstus,
        lstdtedt,
        xchgrate,
        refrence,
        dta_index,
        rtclcmtd,
        openyear,
        user_defined_text01,
        rctrxseq,
        time1,
        revhist,
        lastuser,
        dtatrxtype,
        original_je,
        glhdrval,
        ictrx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
