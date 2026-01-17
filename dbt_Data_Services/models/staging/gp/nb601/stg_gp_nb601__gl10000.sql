with source as (

    select * from {{ source('nb601_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        prntstus,
        lstdtedt,
        glhdrval,
        original_je_seq_num,
        uswhpstd,
        ledger_id,
        original_je,
        balfrclc,
        denxrate,
        orcomid,
        refrence,
        histrx,
        exchdate,
        icdists,
        tax_date,
        rvtrxsrc,
        sourcdoc,
        time1,
        dex_row_ts,
        dex_row_id,
        rcrngtrx,
        trxdate,
        user_defined_text01,
        orpstddt,
        glhdrms2,
        ratetpid,
        originje,
        lastuser,
        sqncline,
        periodid,
        dta_index,
        closedyr,
        rctrxseq,
        correcting_trx_type,
        adjustment_transaction,
        pstgstus,
        trxsorce,
        revhist,
        ictrx,
        exgtblid,
        revprdid,
        docdate,
        user_defined_text02,
        ortrxsrc,
        revyear,
        trxtype,
        mctrxstt,
        voided,
        dtatrxtype,
        noteindx,
        rvrsngdt,
        original_je_year,
        revclyr,
        currnidx,
        curncyid,
        glhdrmsg,
        errstate,
        origdtaseries,
        series,
        xchgrate,
        rtclcmtd,
        dtacontrolnum,
        openyear,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
