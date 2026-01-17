with source as (

    select * from {{ source('wfc_dbo', 'gl10000') }}

),

renamed as (

    select
        trxsorce,
        balfrclc,
        lastuser,
        originje,
        lstdtedt,
        rtclcmtd,
        pstgstus,
        tax_date,
        trxtype,
        histrx,
        refrence,
        ortrxsrc,
        mctrxstt,
        rvtrxsrc,
        denxrate,
        rcrngtrx,
        original_je,
        bachnumb,
        icdists,
        glhdrmsg,
        exchdate,
        rctrxseq,
        xchgrate,
        original_je_year,
        adjustment_transaction,
        revclyr,
        curncyid,
        glhdrval,
        original_je_seq_num,
        voided,
        orpstddt,
        dta_index,
        jrnentry,
        dex_row_id,
        trxdate,
        series,
        dtatrxtype,
        openyear,
        exgtblid,
        revhist,
        ledger_id,
        currnidx,
        noteindx,
        orcomid,
        errstate,
        correcting_trx_type,
        time1,
        glhdrms2,
        uswhpstd,
        ratetpid,
        bchsourc,
        sqncline,
        closedyr,
        prntstus,
        dtacontrolnum,
        periodid,
        user_defined_text02,
        rvrsngdt,
        dex_row_ts,
        revprdid,
        revyear,
        user_defined_text01,
        docdate,
        ictrx,
        sourcdoc,
        origdtaseries,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
