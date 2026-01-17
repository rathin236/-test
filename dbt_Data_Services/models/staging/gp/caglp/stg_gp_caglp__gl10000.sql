with source as (

    select * from {{ source('caglp_dbo', 'gl10000') }}

),

renamed as (

    select
        uswhpstd,
        ledger_id,
        rctrxseq,
        user_defined_text01,
        closedyr,
        ratetpid,
        sqncline,
        rvrsngdt,
        time1,
        series,
        glhdrms2,
        histrx,
        original_je,
        openyear,
        ictrx,
        lstdtedt,
        curncyid,
        orcomid,
        rtclcmtd,
        mctrxstt,
        exgtblid,
        docdate,
        correcting_trx_type,
        errstate,
        pstgstus,
        bachnumb,
        voided,
        xchgrate,
        trxtype,
        dta_index,
        rvtrxsrc,
        jrnentry,
        origdtaseries,
        ortrxsrc,
        dtatrxtype,
        balfrclc,
        dtacontrolnum,
        revhist,
        refrence,
        revclyr,
        user_defined_text02,
        denxrate,
        dex_row_ts,
        glhdrval,
        original_je_year,
        prntstus,
        lastuser,
        periodid,
        bchsourc,
        adjustment_transaction,
        exchdate,
        dex_row_id,
        tax_date,
        icdists,
        originje,
        glhdrmsg,
        sourcdoc,
        revprdid,
        currnidx,
        rcrngtrx,
        noteindx,
        trxsorce,
        orpstddt,
        revyear,
        original_je_seq_num,
        trxdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
