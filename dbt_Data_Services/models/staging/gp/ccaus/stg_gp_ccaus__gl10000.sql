with source as (

    select * from {{ source('ccaus_dbo', 'gl10000') }}

),

renamed as (

    select
        ortrxsrc,
        dex_row_ts,
        jrnentry,
        errstate,
        sourcdoc,
        closedyr,
        sqncline,
        refrence,
        trxdate,
        curncyid,
        user_defined_text02,
        dtacontrolnum,
        ictrx,
        bchsourc,
        noteindx,
        rvtrxsrc,
        ledger_id,
        openyear,
        series,
        icdists,
        docdate,
        mctrxstt,
        rvrsngdt,
        rcrngtrx,
        rtclcmtd,
        bachnumb,
        pstgstus,
        correcting_trx_type,
        voided,
        trxtype,
        origdtaseries,
        glhdrval,
        dta_index,
        glhdrmsg,
        denxrate,
        balfrclc,
        originje,
        dtatrxtype,
        revhist,
        ratetpid,
        exgtblid,
        original_je_seq_num,
        orcomid,
        tax_date,
        dex_row_id,
        revclyr,
        original_je_year,
        lstdtedt,
        uswhpstd,
        adjustment_transaction,
        glhdrms2,
        histrx,
        periodid,
        prntstus,
        original_je,
        time1,
        trxsorce,
        orpstddt,
        currnidx,
        rctrxseq,
        revyear,
        lastuser,
        exchdate,
        xchgrate,
        revprdid,
        user_defined_text01,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
