with source as (

    select * from {{ source('tnm_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        closedyr,
        ratetpid,
        denxrate,
        rcrngtrx,
        exgtblid,
        glhdrval,
        currnidx,
        orpstddt,
        adjustment_transaction,
        dex_row_id,
        xchgrate,
        dta_index,
        ledger_id,
        user_defined_text01,
        originje,
        user_defined_text02,
        revprdid,
        revyear,
        revhist,
        exchdate,
        dtacontrolnum,
        trxdate,
        ictrx,
        periodid,
        prntstus,
        ortrxsrc,
        rvtrxsrc,
        time1,
        histrx,
        orcomid,
        glhdrmsg,
        trxtype,
        rctrxseq,
        icdists,
        balfrclc,
        sqncline,
        curncyid,
        noteindx,
        refrence,
        rtclcmtd,
        sourcdoc,
        docdate,
        trxsorce,
        original_je_year,
        tax_date,
        errstate,
        lastuser,
        series,
        dtatrxtype,
        lstdtedt,
        origdtaseries,
        openyear,
        revclyr,
        original_je,
        dex_row_ts,
        glhdrms2,
        original_je_seq_num,
        pstgstus,
        correcting_trx_type,
        voided,
        rvrsngdt,
        uswhpstd,
        mctrxstt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
