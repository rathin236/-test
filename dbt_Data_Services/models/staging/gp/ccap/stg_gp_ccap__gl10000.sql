with source as (

    select * from {{ source('ccap_dbo', 'gl10000') }}

),

renamed as (

    select
        series,
        user_defined_text01,
        openyear,
        errstate,
        uswhpstd,
        orcomid,
        trxdate,
        dtatrxtype,
        exgtblid,
        glhdrmsg,
        icdists,
        denxrate,
        origdtaseries,
        jrnentry,
        ictrx,
        tax_date,
        ledger_id,
        bchsourc,
        original_je_year,
        docdate,
        originje,
        balfrclc,
        rvrsngdt,
        dex_row_ts,
        periodid,
        ratetpid,
        revprdid,
        prntstus,
        trxtype,
        rvtrxsrc,
        voided,
        ortrxsrc,
        rcrngtrx,
        bachnumb,
        revyear,
        glhdrms2,
        trxsorce,
        currnidx,
        rctrxseq,
        adjustment_transaction,
        revclyr,
        revhist,
        curncyid,
        sqncline,
        sourcdoc,
        dex_row_id,
        lstdtedt,
        pstgstus,
        xchgrate,
        correcting_trx_type,
        time1,
        orpstddt,
        dta_index,
        lastuser,
        glhdrval,
        rtclcmtd,
        original_je,
        histrx,
        noteindx,
        closedyr,
        dtacontrolnum,
        exchdate,
        refrence,
        original_je_seq_num,
        mctrxstt,
        user_defined_text02,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
