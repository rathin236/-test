with source as (

    select * from {{ source('chsi_dbo', 'gl10000') }}

),

renamed as (

    select
        rvrsngdt,
        icdists,
        original_je_seq_num,
        ledger_id,
        correcting_trx_type,
        noteindx,
        trxdate,
        orpstddt,
        lastuser,
        currnidx,
        series,
        openyear,
        user_defined_text01,
        glhdrval,
        periodid,
        xchgrate,
        prntstus,
        exgtblid,
        dta_index,
        rvtrxsrc,
        curncyid,
        refrence,
        denxrate,
        revprdid,
        originje,
        ortrxsrc,
        voided,
        rctrxseq,
        orcomid,
        jrnentry,
        balfrclc,
        adjustment_transaction,
        dex_row_id,
        glhdrmsg,
        time1,
        revclyr,
        trxtype,
        bchsourc,
        exchdate,
        dtacontrolnum,
        tax_date,
        original_je_year,
        pstgstus,
        user_defined_text02,
        lstdtedt,
        revyear,
        origdtaseries,
        docdate,
        rcrngtrx,
        histrx,
        original_je,
        dtatrxtype,
        bachnumb,
        ratetpid,
        revhist,
        mctrxstt,
        sourcdoc,
        rtclcmtd,
        errstate,
        trxsorce,
        sqncline,
        closedyr,
        uswhpstd,
        dex_row_ts,
        glhdrms2,
        ictrx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
