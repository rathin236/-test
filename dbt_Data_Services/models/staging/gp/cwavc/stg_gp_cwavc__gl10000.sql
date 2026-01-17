with source as (

    select * from {{ source('cwavc_dbo', 'gl10000') }}

),

renamed as (

    select
        docdate,
        rtclcmtd,
        user_defined_text02,
        mctrxstt,
        lstdtedt,
        original_je_seq_num,
        tax_date,
        sourcdoc,
        trxtype,
        bachnumb,
        balfrclc,
        dex_row_ts,
        trxsorce,
        histrx,
        noteindx,
        revclyr,
        rctrxseq,
        denxrate,
        pstgstus,
        original_je_year,
        correcting_trx_type,
        rvrsngdt,
        xchgrate,
        series,
        openyear,
        ledger_id,
        dex_row_id,
        revhist,
        bchsourc,
        ratetpid,
        dta_index,
        dtatrxtype,
        uswhpstd,
        glhdrmsg,
        ictrx,
        originje,
        currnidx,
        orpstddt,
        jrnentry,
        rcrngtrx,
        time1,
        glhdrval,
        periodid,
        prntstus,
        closedyr,
        user_defined_text01,
        exgtblid,
        exchdate,
        original_je,
        adjustment_transaction,
        lastuser,
        sqncline,
        revprdid,
        icdists,
        revyear,
        refrence,
        curncyid,
        origdtaseries,
        glhdrms2,
        rvtrxsrc,
        dtacontrolnum,
        errstate,
        orcomid,
        ortrxsrc,
        voided,
        trxdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
