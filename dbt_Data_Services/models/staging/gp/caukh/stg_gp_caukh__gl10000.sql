with source as (

    select * from {{ source('caukh_dbo', 'gl10000') }}

),

renamed as (

    select
        balfrclc,
        icdists,
        dtatrxtype,
        rtclcmtd,
        dtacontrolnum,
        origdtaseries,
        mctrxstt,
        bchsourc,
        exchdate,
        glhdrms2,
        original_je_seq_num,
        pstgstus,
        exgtblid,
        series,
        orcomid,
        orpstddt,
        noteindx,
        revprdid,
        time1,
        ortrxsrc,
        user_defined_text01,
        revyear,
        refrence,
        openyear,
        rvtrxsrc,
        lstdtedt,
        dta_index,
        sourcdoc,
        revclyr,
        errstate,
        rctrxseq,
        prntstus,
        voided,
        trxtype,
        denxrate,
        user_defined_text02,
        original_je_year,
        adjustment_transaction,
        periodid,
        xchgrate,
        lastuser,
        rcrngtrx,
        closedyr,
        originje,
        glhdrmsg,
        histrx,
        ledger_id,
        glhdrval,
        trxsorce,
        correcting_trx_type,
        docdate,
        trxdate,
        original_je,
        currnidx,
        uswhpstd,
        revhist,
        curncyid,
        tax_date,
        ratetpid,
        sqncline,
        dex_row_ts,
        rvrsngdt,
        bachnumb,
        dex_row_id,
        jrnentry,
        ictrx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
