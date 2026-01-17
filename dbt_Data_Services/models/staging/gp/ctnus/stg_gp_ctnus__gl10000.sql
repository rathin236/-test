with source as (

    select * from {{ source('ctnus_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        glhdrmsg,
        rvrsngdt,
        glhdrval,
        prntstus,
        periodid,
        time1,
        dta_index,
        currnidx,
        orcomid,
        denxrate,
        trxdate,
        originje,
        adjustment_transaction,
        dex_row_ts,
        ledger_id,
        dex_row_id,
        ictrx,
        user_defined_text01,
        revclyr,
        xchgrate,
        original_je_year,
        trxtype,
        lastuser,
        histrx,
        exgtblid,
        docdate,
        revprdid,
        revyear,
        user_defined_text02,
        rvtrxsrc,
        dtacontrolnum,
        lstdtedt,
        ortrxsrc,
        revhist,
        series,
        openyear,
        sqncline,
        curncyid,
        errstate,
        refrence,
        balfrclc,
        trxsorce,
        dtatrxtype,
        origdtaseries,
        glhdrms2,
        sourcdoc,
        rctrxseq,
        exchdate,
        voided,
        pstgstus,
        correcting_trx_type,
        icdists,
        rcrngtrx,
        orpstddt,
        ratetpid,
        closedyr,
        original_je_seq_num,
        rtclcmtd,
        original_je,
        mctrxstt,
        uswhpstd,
        noteindx,
        tax_date,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
