with source as (

    select * from {{ source('cagsf_dbo', 'gl10000') }}

),

renamed as (

    select
        trxtype,
        pstgstus,
        exgtblid,
        original_je_year,
        tax_date,
        lstdtedt,
        ratetpid,
        originje,
        rtclcmtd,
        dtacontrolnum,
        bchsourc,
        revclyr,
        dex_row_id,
        original_je_seq_num,
        noteindx,
        user_defined_text02,
        origdtaseries,
        dtatrxtype,
        docdate,
        bachnumb,
        ortrxsrc,
        openyear,
        histrx,
        series,
        adjustment_transaction,
        icdists,
        sqncline,
        revprdid,
        exchdate,
        revyear,
        curncyid,
        orcomid,
        balfrclc,
        periodid,
        prntstus,
        ledger_id,
        errstate,
        time1,
        glhdrmsg,
        correcting_trx_type,
        glhdrval,
        lastuser,
        voided,
        rcrngtrx,
        refrence,
        rvtrxsrc,
        currnidx,
        jrnentry,
        orpstddt,
        trxdate,
        uswhpstd,
        dex_row_ts,
        denxrate,
        glhdrms2,
        user_defined_text01,
        dta_index,
        rvrsngdt,
        mctrxstt,
        xchgrate,
        revhist,
        ictrx,
        original_je,
        trxsorce,
        sourcdoc,
        closedyr,
        rctrxseq,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
