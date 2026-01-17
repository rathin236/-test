with source as (

    select * from {{ source('tns_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        errstate,
        lastuser,
        periodid,
        prntstus,
        icdists,
        revyear,
        refrence,
        glhdrms2,
        trxsorce,
        rvtrxsrc,
        curncyid,
        closedyr,
        tax_date,
        lstdtedt,
        rctrxseq,
        ortrxsrc,
        trxtype,
        docdate,
        ictrx,
        origdtaseries,
        denxrate,
        user_defined_text02,
        originje,
        sourcdoc,
        histrx,
        rvrsngdt,
        currnidx,
        user_defined_text01,
        trxdate,
        dex_row_ts,
        rcrngtrx,
        exgtblid,
        series,
        openyear,
        original_je_seq_num,
        mctrxstt,
        revprdid,
        dtacontrolnum,
        orcomid,
        xchgrate,
        dta_index,
        ratetpid,
        voided,
        uswhpstd,
        revhist,
        adjustment_transaction,
        dex_row_id,
        balfrclc,
        orpstddt,
        noteindx,
        revclyr,
        time1,
        pstgstus,
        ledger_id,
        glhdrval,
        original_je_year,
        correcting_trx_type,
        sqncline,
        original_je,
        dtatrxtype,
        glhdrmsg,
        rtclcmtd,
        exchdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
