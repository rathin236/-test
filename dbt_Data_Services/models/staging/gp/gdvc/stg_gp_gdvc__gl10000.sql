with source as (

    select * from {{ source('gdvc_dbo', 'gl10000') }}

),

renamed as (

    select
        orpstddt,
        periodid,
        denxrate,
        lastuser,
        rvtrxsrc,
        currnidx,
        icdists,
        xchgrate,
        glhdrms2,
        errstate,
        rvrsngdt,
        sourcdoc,
        dta_index,
        glhdrmsg,
        trxsorce,
        curncyid,
        time1,
        ledger_id,
        revclyr,
        exchdate,
        bchsourc,
        original_je,
        bachnumb,
        uswhpstd,
        closedyr,
        tax_date,
        voided,
        glhdrval,
        trxdate,
        jrnentry,
        dex_row_id,
        pstgstus,
        correcting_trx_type,
        adjustment_transaction,
        rctrxseq,
        mctrxstt,
        sqncline,
        ratetpid,
        histrx,
        exgtblid,
        dtatrxtype,
        rtclcmtd,
        orcomid,
        docdate,
        balfrclc,
        noteindx,
        originje,
        user_defined_text01,
        rcrngtrx,
        series,
        openyear,
        origdtaseries,
        original_je_year,
        dex_row_ts,
        user_defined_text02,
        dtacontrolnum,
        original_je_seq_num,
        ortrxsrc,
        ictrx,
        lstdtedt,
        revyear,
        revhist,
        prntstus,
        trxtype,
        refrence,
        revprdid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
