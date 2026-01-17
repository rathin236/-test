with source as (

    select * from {{ source('cafl_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        mctrxstt,
        rtclcmtd,
        dtatrxtype,
        balfrclc,
        dta_index,
        uswhpstd,
        denxrate,
        docdate,
        originje,
        exchdate,
        pstgstus,
        xchgrate,
        revprdid,
        trxtype,
        icdists,
        dex_row_id,
        orcomid,
        refrence,
        voided,
        user_defined_text01,
        trxsorce,
        rvtrxsrc,
        sourcdoc,
        lstdtedt,
        origdtaseries,
        lastuser,
        glhdrms2,
        errstate,
        adjustment_transaction,
        ictrx,
        time1,
        user_defined_text02,
        histrx,
        rvrsngdt,
        dex_row_ts,
        dtacontrolnum,
        currnidx,
        orpstddt,
        sqncline,
        ortrxsrc,
        closedyr,
        rctrxseq,
        trxdate,
        revyear,
        exgtblid,
        glhdrval,
        periodid,
        prntstus,
        correcting_trx_type,
        noteindx,
        curncyid,
        rcrngtrx,
        ratetpid,
        revhist,
        ledger_id,
        openyear,
        series,
        original_je,
        tax_date,
        original_je_year,
        glhdrmsg,
        revclyr,
        original_je_seq_num,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
