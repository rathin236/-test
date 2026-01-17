with source as (

    select * from {{ source('nns_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        time1,
        original_je_year,
        pstgstus,
        origdtaseries,
        originje,
        glhdrms2,
        ortrxsrc,
        revclyr,
        trxtype,
        refrence,
        denxrate,
        rvtrxsrc,
        balfrclc,
        original_je,
        dtacontrolnum,
        user_defined_text02,
        icdists,
        trxdate,
        orpstddt,
        periodid,
        lastuser,
        exchdate,
        prntstus,
        sqncline,
        revhist,
        revyear,
        revprdid,
        sourcdoc,
        currnidx,
        trxsorce,
        dex_row_id,
        correcting_trx_type,
        histrx,
        tax_date,
        ledger_id,
        adjustment_transaction,
        rcrngtrx,
        glhdrval,
        lstdtedt,
        uswhpstd,
        user_defined_text01,
        original_je_seq_num,
        glhdrmsg,
        closedyr,
        ratetpid,
        ictrx,
        docdate,
        voided,
        noteindx,
        series,
        dtatrxtype,
        openyear,
        errstate,
        mctrxstt,
        rctrxseq,
        rvrsngdt,
        dta_index,
        dex_row_ts,
        orcomid,
        rtclcmtd,
        exgtblid,
        xchgrate,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
