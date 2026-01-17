with source as (

    select * from {{ source('calp_dbo', 'gl10000') }}

),

renamed as (

    select
        rctrxseq,
        refrence,
        sqncline,
        rvtrxsrc,
        adjustment_transaction,
        docdate,
        curncyid,
        noteindx,
        closedyr,
        histrx,
        lastuser,
        jrnentry,
        bachnumb,
        currnidx,
        glhdrms2,
        periodid,
        trxsorce,
        correcting_trx_type,
        sourcdoc,
        errstate,
        glhdrmsg,
        revprdid,
        ictrx,
        voided,
        original_je_seq_num,
        exchdate,
        dex_row_id,
        original_je,
        ortrxsrc,
        rcrngtrx,
        lstdtedt,
        user_defined_text02,
        dta_index,
        dtacontrolnum,
        trxtype,
        orpstddt,
        user_defined_text01,
        origdtaseries,
        exgtblid,
        balfrclc,
        xchgrate,
        time1,
        orcomid,
        rtclcmtd,
        originje,
        icdists,
        mctrxstt,
        revhist,
        revyear,
        pstgstus,
        denxrate,
        series,
        dex_row_ts,
        prntstus,
        openyear,
        rvrsngdt,
        trxdate,
        dtatrxtype,
        glhdrval,
        uswhpstd,
        revclyr,
        tax_date,
        bchsourc,
        original_je_year,
        ratetpid,
        ledger_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
