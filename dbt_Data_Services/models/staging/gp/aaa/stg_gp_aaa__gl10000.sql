with source as (

    select * from {{ source('aaa_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        exgtblid,
        voided,
        originje,
        ratetpid,
        series,
        openyear,
        dex_row_id,
        dta_index,
        dtatrxtype,
        xchgrate,
        revhist,
        user_defined_text01,
        ledger_id,
        closedyr,
        glhdrval,
        histrx,
        rvrsngdt,
        original_je,
        dex_row_ts,
        denxrate,
        mctrxstt,
        docdate,
        rtclcmtd,
        pstgstus,
        correcting_trx_type,
        errstate,
        uswhpstd,
        revyear,
        lastuser,
        glhdrms2,
        trxsorce,
        refrence,
        curncyid,
        revclyr,
        ictrx,
        sourcdoc,
        tax_date,
        lstdtedt,
        original_je_year,
        rctrxseq,
        adjustment_transaction,
        noteindx,
        user_defined_text02,
        glhdrmsg,
        origdtaseries,
        icdists,
        balfrclc,
        time1,
        dtacontrolnum,
        sqncline,
        currnidx,
        rcrngtrx,
        trxdate,
        orpstddt,
        original_je_seq_num,
        periodid,
        orcomid,
        prntstus,
        rvtrxsrc,
        trxtype,
        ortrxsrc,
        exchdate,
        revprdid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
