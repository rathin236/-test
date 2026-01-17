with source as (

    select * from {{ source('culcg_dbo', 'gl10000') }}

),

renamed as (

    select
        exchdate,
        ratetpid,
        exgtblid,
        pstgstus,
        orcomid,
        icdists,
        originje,
        revyear,
        dex_row_id,
        bchsourc,
        trxtype,
        prntstus,
        ictrx,
        mctrxstt,
        uswhpstd,
        periodid,
        dtatrxtype,
        sqncline,
        balfrclc,
        histrx,
        rtclcmtd,
        glhdrval,
        lstdtedt,
        openyear,
        glhdrmsg,
        time1,
        original_je_year,
        series,
        bachnumb,
        ledger_id,
        revclyr,
        voided,
        original_je_seq_num,
        correcting_trx_type,
        dex_row_ts,
        glhdrms2,
        trxsorce,
        refrence,
        curncyid,
        revhist,
        closedyr,
        noteindx,
        rvtrxsrc,
        adjustment_transaction,
        ortrxsrc,
        revprdid,
        trxdate,
        orpstddt,
        denxrate,
        user_defined_text02,
        docdate,
        rctrxseq,
        jrnentry,
        dtacontrolnum,
        tax_date,
        errstate,
        dta_index,
        currnidx,
        origdtaseries,
        rvrsngdt,
        sourcdoc,
        rcrngtrx,
        lastuser,
        xchgrate,
        original_je,
        user_defined_text01,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
