with source as (

    select * from {{ source('cos_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        exchdate,
        revhist,
        user_defined_text02,
        revyear,
        curncyid,
        currnidx,
        revclyr,
        original_je,
        sourcdoc,
        errstate,
        origdtaseries,
        ledger_id,
        docdate,
        voided,
        dex_row_id,
        lastuser,
        original_je_year,
        sqncline,
        exgtblid,
        rcrngtrx,
        originje,
        glhdrms2,
        dtacontrolnum,
        refrence,
        orcomid,
        balfrclc,
        lstdtedt,
        trxtype,
        revprdid,
        ortrxsrc,
        rvtrxsrc,
        icdists,
        periodid,
        prntstus,
        openyear,
        dex_row_ts,
        uswhpstd,
        ictrx,
        trxdate,
        original_je_seq_num,
        adjustment_transaction,
        time1,
        noteindx,
        rvrsngdt,
        dtatrxtype,
        user_defined_text01,
        series,
        orpstddt,
        xchgrate,
        closedyr,
        dta_index,
        pstgstus,
        denxrate,
        glhdrmsg,
        trxsorce,
        rtclcmtd,
        glhdrval,
        mctrxstt,
        ratetpid,
        histrx,
        tax_date,
        correcting_trx_type,
        rctrxseq,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
