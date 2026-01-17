with source as (

    select * from {{ source('cai_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        rctrxseq,
        user_defined_text01,
        lstdtedt,
        trxtype,
        orcomid,
        origdtaseries,
        docdate,
        errstate,
        revhist,
        rcrngtrx,
        sqncline,
        exgtblid,
        rtclcmtd,
        mctrxstt,
        ratetpid,
        noteindx,
        revyear,
        pstgstus,
        voided,
        tax_date,
        uswhpstd,
        series,
        prntstus,
        periodid,
        openyear,
        dex_row_ts,
        dtatrxtype,
        rvrsngdt,
        balfrclc,
        revclyr,
        original_je,
        ledger_id,
        original_je_year,
        glhdrmsg,
        rvtrxsrc,
        denxrate,
        glhdrval,
        sourcdoc,
        dta_index,
        closedyr,
        orpstddt,
        time1,
        refrence,
        curncyid,
        originje,
        revprdid,
        user_defined_text02,
        currnidx,
        ictrx,
        ortrxsrc,
        icdists,
        correcting_trx_type,
        dex_row_id,
        original_je_seq_num,
        trxdate,
        adjustment_transaction,
        dtacontrolnum,
        glhdrms2,
        histrx,
        trxsorce,
        lastuser,
        exchdate,
        xchgrate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
