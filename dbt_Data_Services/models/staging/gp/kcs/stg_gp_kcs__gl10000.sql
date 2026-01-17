with source as (

    select * from {{ source('kcs_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        dta_index,
        revprdid,
        openyear,
        original_je,
        denxrate,
        xchgrate,
        docdate,
        user_defined_text01,
        lstdtedt,
        mctrxstt,
        balfrclc,
        ictrx,
        tax_date,
        adjustment_transaction,
        dex_row_id,
        closedyr,
        icdists,
        rvrsngdt,
        ratetpid,
        rtclcmtd,
        dex_row_ts,
        errstate,
        ledger_id,
        original_je_year,
        pstgstus,
        correcting_trx_type,
        trxsorce,
        revclyr,
        noteindx,
        rcrngtrx,
        dtatrxtype,
        uswhpstd,
        series,
        original_je_seq_num,
        revyear,
        sqncline,
        revhist,
        rctrxseq,
        orpstddt,
        user_defined_text02,
        periodid,
        sourcdoc,
        glhdrms2,
        prntstus,
        glhdrmsg,
        voided,
        trxtype,
        exgtblid,
        lastuser,
        origdtaseries,
        histrx,
        time1,
        curncyid,
        originje,
        refrence,
        trxdate,
        rvtrxsrc,
        dtacontrolnum,
        orcomid,
        exchdate,
        currnidx,
        ortrxsrc,
        glhdrval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
