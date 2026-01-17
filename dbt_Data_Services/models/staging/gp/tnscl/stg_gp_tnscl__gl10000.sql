with source as (

    select * from {{ source('tnscl_dbo', 'gl10000') }}

),

renamed as (

    select
        lastuser,
        ledger_id,
        currnidx,
        trxsorce,
        periodid,
        glhdrmsg,
        correcting_trx_type,
        jrnentry,
        sqncline,
        rvtrxsrc,
        prntstus,
        lstdtedt,
        closedyr,
        icdists,
        uswhpstd,
        glhdrms2,
        tax_date,
        bachnumb,
        orpstddt,
        revhist,
        curncyid,
        original_je_year,
        time1,
        revclyr,
        series,
        exchdate,
        glhdrval,
        openyear,
        dtatrxtype,
        histrx,
        rvrsngdt,
        balfrclc,
        dex_row_ts,
        original_je_seq_num,
        exgtblid,
        trxdate,
        rtclcmtd,
        ictrx,
        adjustment_transaction,
        xchgrate,
        rcrngtrx,
        ratetpid,
        originje,
        pstgstus,
        trxtype,
        user_defined_text02,
        bchsourc,
        dtacontrolnum,
        orcomid,
        denxrate,
        dex_row_id,
        mctrxstt,
        ortrxsrc,
        noteindx,
        errstate,
        revprdid,
        voided,
        rctrxseq,
        docdate,
        revyear,
        refrence,
        dta_index,
        sourcdoc,
        original_je,
        origdtaseries,
        user_defined_text01,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
