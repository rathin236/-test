with source as (

    select * from {{ source('cibl_dbo', 'gl10000') }}

),

renamed as (

    select
        denxrate,
        trxdate,
        glhdrms2,
        currnidx,
        dex_row_ts,
        revhist,
        xchgrate,
        ratetpid,
        rvrsngdt,
        correcting_trx_type,
        periodid,
        time1,
        closedyr,
        prntstus,
        orcomid,
        exgtblid,
        docdate,
        uswhpstd,
        glhdrval,
        bachnumb,
        jrnentry,
        bchsourc,
        series,
        originje,
        ledger_id,
        original_je_year,
        histrx,
        lstdtedt,
        revclyr,
        openyear,
        rtclcmtd,
        sqncline,
        rctrxseq,
        lastuser,
        dtatrxtype,
        balfrclc,
        trxsorce,
        exchdate,
        noteindx,
        ictrx,
        dex_row_id,
        sourcdoc,
        rvtrxsrc,
        original_je,
        curncyid,
        pstgstus,
        adjustment_transaction,
        revprdid,
        trxtype,
        mctrxstt,
        glhdrmsg,
        orpstddt,
        errstate,
        icdists,
        user_defined_text02,
        ortrxsrc,
        revyear,
        dtacontrolnum,
        original_je_seq_num,
        voided,
        user_defined_text01,
        refrence,
        rcrngtrx,
        tax_date,
        origdtaseries,
        dta_index,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
