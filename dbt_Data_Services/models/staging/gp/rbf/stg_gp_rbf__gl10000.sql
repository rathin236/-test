with source as (

    select * from {{ source('rbf_dbo', 'gl10000') }}

),

renamed as (

    select
        original_je_seq_num,
        correcting_trx_type,
        glhdrms2,
        histrx,
        closedyr,
        trxdate,
        ledger_id,
        orcomid,
        dex_row_ts,
        ratetpid,
        noteindx,
        rvrsngdt,
        jrnentry,
        uswhpstd,
        sqncline,
        prntstus,
        voided,
        exgtblid,
        time1,
        rcrngtrx,
        periodid,
        docdate,
        errstate,
        revprdid,
        icdists,
        original_je,
        lstdtedt,
        revyear,
        adjustment_transaction,
        currnidx,
        bachnumb,
        pstgstus,
        original_je_year,
        originje,
        revclyr,
        origdtaseries,
        user_defined_text02,
        trxtype,
        balfrclc,
        curncyid,
        dtacontrolnum,
        exchdate,
        rvtrxsrc,
        bchsourc,
        glhdrval,
        dex_row_id,
        ortrxsrc,
        denxrate,
        lastuser,
        series,
        tax_date,
        dta_index,
        rctrxseq,
        xchgrate,
        openyear,
        orpstddt,
        refrence,
        trxsorce,
        mctrxstt,
        sourcdoc,
        dtatrxtype,
        rtclcmtd,
        revhist,
        user_defined_text01,
        glhdrmsg,
        ictrx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
