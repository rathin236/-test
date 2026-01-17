with source as (

    select * from {{ source('cgdv2_dbo', 'gl10000') }}

),

renamed as (

    select
        series,
        ictrx,
        time1,
        mctrxstt,
        exgtblid,
        rvrsngdt,
        dex_row_ts,
        noteindx,
        dtatrxtype,
        rtclcmtd,
        origdtaseries,
        openyear,
        bachnumb,
        user_defined_text01,
        original_je_year,
        trxtype,
        sourcdoc,
        glhdrval,
        histrx,
        revclyr,
        adjustment_transaction,
        revprdid,
        ledger_id,
        glhdrms2,
        docdate,
        originje,
        ratetpid,
        sqncline,
        jrnentry,
        bchsourc,
        balfrclc,
        uswhpstd,
        dex_row_id,
        errstate,
        prntstus,
        periodid,
        xchgrate,
        dta_index,
        revhist,
        trxsorce,
        voided,
        original_je,
        lstdtedt,
        revyear,
        lastuser,
        tax_date,
        currnidx,
        icdists,
        original_je_seq_num,
        pstgstus,
        correcting_trx_type,
        glhdrmsg,
        curncyid,
        orcomid,
        refrence,
        rcrngtrx,
        orpstddt,
        user_defined_text02,
        rctrxseq,
        exchdate,
        closedyr,
        trxdate,
        dtacontrolnum,
        denxrate,
        rvtrxsrc,
        ortrxsrc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
