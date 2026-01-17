with source as (

    select * from {{ source('gcags_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        prntstus,
        glhdrms2,
        periodid,
        original_je,
        ictrx,
        revyear,
        adjustment_transaction,
        rctrxseq,
        sqncline,
        uswhpstd,
        lstdtedt,
        tax_date,
        closedyr,
        dex_row_id,
        glhdrval,
        original_je_year,
        ratetpid,
        curncyid,
        orcomid,
        revclyr,
        ledger_id,
        correcting_trx_type,
        pstgstus,
        time1,
        trxdate,
        orpstddt,
        errstate,
        rtclcmtd,
        original_je_seq_num,
        openyear,
        histrx,
        dtatrxtype,
        exchdate,
        noteindx,
        dtacontrolnum,
        revhist,
        series,
        dta_index,
        user_defined_text02,
        denxrate,
        revprdid,
        balfrclc,
        ortrxsrc,
        exgtblid,
        mctrxstt,
        xchgrate,
        refrence,
        trxtype,
        rvrsngdt,
        originje,
        glhdrmsg,
        icdists,
        rvtrxsrc,
        trxsorce,
        sourcdoc,
        dex_row_ts,
        voided,
        docdate,
        currnidx,
        origdtaseries,
        user_defined_text01,
        rcrngtrx,
        lastuser,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
