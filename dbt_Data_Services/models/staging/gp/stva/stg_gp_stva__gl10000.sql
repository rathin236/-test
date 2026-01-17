with source as (

    select * from {{ source('stva_dbo', 'gl10000') }}

),

renamed as (

    select
        revprdid,
        docdate,
        user_defined_text01,
        uswhpstd,
        glhdrval,
        denxrate,
        openyear,
        orcomid,
        tax_date,
        lstdtedt,
        glhdrmsg,
        dta_index,
        xchgrate,
        series,
        ictrx,
        ledger_id,
        adjustment_transaction,
        ratetpid,
        trxdate,
        dex_row_ts,
        rtclcmtd,
        glhdrms2,
        dtatrxtype,
        closedyr,
        rvrsngdt,
        exgtblid,
        curncyid,
        mctrxstt,
        original_je_seq_num,
        pstgstus,
        histrx,
        correcting_trx_type,
        orpstddt,
        noteindx,
        rctrxseq,
        ortrxsrc,
        bachnumb,
        voided,
        dex_row_id,
        original_je_year,
        user_defined_text02,
        revclyr,
        sqncline,
        rvtrxsrc,
        dtacontrolnum,
        bchsourc,
        refrence,
        revhist,
        originje,
        icdists,
        errstate,
        exchdate,
        origdtaseries,
        currnidx,
        jrnentry,
        balfrclc,
        lastuser,
        original_je,
        trxsorce,
        periodid,
        trxtype,
        time1,
        prntstus,
        revyear,
        sourcdoc,
        rcrngtrx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
