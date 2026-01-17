with source as (

    select * from {{ source('causa_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        orcomid,
        rvrsngdt,
        user_defined_text01,
        dex_row_ts,
        ratetpid,
        uswhpstd,
        mctrxstt,
        xchgrate,
        time1,
        balfrclc,
        revprdid,
        exgtblid,
        ledger_id,
        dtacontrolnum,
        histrx,
        pstgstus,
        original_je_year,
        correcting_trx_type,
        denxrate,
        user_defined_text02,
        dex_row_id,
        rtclcmtd,
        glhdrms2,
        trxdate,
        lastuser,
        revclyr,
        ictrx,
        originje,
        orpstddt,
        dtatrxtype,
        series,
        openyear,
        refrence,
        curncyid,
        exchdate,
        glhdrmsg,
        sourcdoc,
        rvtrxsrc,
        glhdrval,
        revyear,
        revhist,
        lstdtedt,
        ortrxsrc,
        tax_date,
        sqncline,
        trxsorce,
        trxtype,
        rctrxseq,
        closedyr,
        periodid,
        prntstus,
        noteindx,
        adjustment_transaction,
        original_je,
        dta_index,
        rcrngtrx,
        currnidx,
        icdists,
        errstate,
        original_je_seq_num,
        docdate,
        voided,
        origdtaseries,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
