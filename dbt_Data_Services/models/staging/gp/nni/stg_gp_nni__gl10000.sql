with source as (

    select * from {{ source('nni_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        rvrsngdt,
        revclyr,
        icdists,
        sourcdoc,
        curncyid,
        refrence,
        user_defined_text02,
        revyear,
        originje,
        time1,
        dex_row_ts,
        trxtype,
        rvtrxsrc,
        dtacontrolnum,
        original_je_seq_num,
        noteindx,
        pstgstus,
        dex_row_id,
        ortrxsrc,
        glhdrmsg,
        mctrxstt,
        currnidx,
        sqncline,
        voided,
        exgtblid,
        docdate,
        origdtaseries,
        original_je,
        lstdtedt,
        histrx,
        glhdrms2,
        errstate,
        orcomid,
        adjustment_transaction,
        closedyr,
        ratetpid,
        rcrngtrx,
        exchdate,
        revprdid,
        uswhpstd,
        correcting_trx_type,
        rtclcmtd,
        periodid,
        glhdrval,
        revhist,
        prntstus,
        balfrclc,
        dtatrxtype,
        denxrate,
        orpstddt,
        ictrx,
        dta_index,
        trxdate,
        openyear,
        xchgrate,
        ledger_id,
        trxsorce,
        series,
        lastuser,
        rctrxseq,
        tax_date,
        user_defined_text01,
        original_je_year,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
