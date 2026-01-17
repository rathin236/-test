with source as (

    select * from {{ source('ccii_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        adjustment_transaction,
        dtacontrolnum,
        revprdid,
        user_defined_text02,
        histrx,
        rcrngtrx,
        series,
        rvtrxsrc,
        openyear,
        correcting_trx_type,
        ortrxsrc,
        lstdtedt,
        tax_date,
        trxsorce,
        rtclcmtd,
        refrence,
        trxdate,
        closedyr,
        origdtaseries,
        denxrate,
        mctrxstt,
        user_defined_text01,
        sourcdoc,
        voided,
        lastuser,
        glhdrmsg,
        exchdate,
        dex_row_id,
        time1,
        glhdrval,
        icdists,
        revclyr,
        orpstddt,
        rvrsngdt,
        trxtype,
        pstgstus,
        rctrxseq,
        uswhpstd,
        revyear,
        originje,
        orcomid,
        currnidx,
        dtatrxtype,
        balfrclc,
        glhdrms2,
        xchgrate,
        errstate,
        sqncline,
        exgtblid,
        ratetpid,
        revhist,
        curncyid,
        periodid,
        ledger_id,
        dta_index,
        ictrx,
        noteindx,
        original_je,
        prntstus,
        dex_row_ts,
        docdate,
        original_je_year,
        original_je_seq_num,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
