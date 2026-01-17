with source as (

    select * from {{ source('stusa_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        original_je,
        revyear,
        sqncline,
        ictrx,
        rctrxseq,
        ortrxsrc,
        rvtrxsrc,
        dtacontrolnum,
        noteindx,
        glhdrval,
        histrx,
        refrence,
        periodid,
        user_defined_text02,
        trxtype,
        prntstus,
        rcrngtrx,
        closedyr,
        ledger_id,
        icdists,
        rtclcmtd,
        voided,
        pstgstus,
        correcting_trx_type,
        docdate,
        original_je_year,
        revclyr,
        errstate,
        adjustment_transaction,
        curncyid,
        orcomid,
        dex_row_ts,
        rvrsngdt,
        dtatrxtype,
        exgtblid,
        glhdrms2,
        openyear,
        uswhpstd,
        dta_index,
        xchgrate,
        series,
        denxrate,
        revprdid,
        user_defined_text01,
        trxdate,
        ratetpid,
        mctrxstt,
        balfrclc,
        tax_date,
        original_je_seq_num,
        lstdtedt,
        time1,
        origdtaseries,
        lastuser,
        orpstddt,
        currnidx,
        sourcdoc,
        dex_row_id,
        trxsorce,
        originje,
        glhdrmsg,
        exchdate,
        revhist,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
