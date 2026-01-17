with source as (

    select * from {{ source('lbfl_dbo', 'gl10000') }}

),

renamed as (

    select
        exgtblid,
        glhdrmsg,
        ictrx,
        original_je_seq_num,
        glhdrval,
        docdate,
        ratetpid,
        tax_date,
        lstdtedt,
        bchsourc,
        origdtaseries,
        adjustment_transaction,
        uswhpstd,
        revclyr,
        orcomid,
        xchgrate,
        rctrxseq,
        original_je_year,
        trxdate,
        sqncline,
        currnidx,
        exchdate,
        periodid,
        dta_index,
        user_defined_text02,
        balfrclc,
        dtacontrolnum,
        original_je,
        user_defined_text01,
        histrx,
        prntstus,
        trxtype,
        revyear,
        revprdid,
        noteindx,
        lastuser,
        orpstddt,
        trxsorce,
        errstate,
        revhist,
        jrnentry,
        refrence,
        time1,
        sourcdoc,
        series,
        rvrsngdt,
        rvtrxsrc,
        curncyid,
        openyear,
        icdists,
        ortrxsrc,
        voided,
        ledger_id,
        dtatrxtype,
        rtclcmtd,
        rcrngtrx,
        dex_row_ts,
        mctrxstt,
        dex_row_id,
        glhdrms2,
        closedyr,
        denxrate,
        originje,
        bachnumb,
        pstgstus,
        correcting_trx_type,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
