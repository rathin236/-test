with source as (

    select * from {{ source('sti_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        closedyr,
        originje,
        ledger_id,
        user_defined_text02,
        glhdrmsg,
        dtacontrolnum,
        dex_row_id,
        rctrxseq,
        glhdrval,
        ictrx,
        trxdate,
        noteindx,
        docdate,
        correcting_trx_type,
        sourcdoc,
        prntstus,
        revprdid,
        periodid,
        curncyid,
        adjustment_transaction,
        rvrsngdt,
        revyear,
        ratetpid,
        icdists,
        tax_date,
        currnidx,
        dex_row_ts,
        rcrngtrx,
        denxrate,
        origdtaseries,
        xchgrate,
        dta_index,
        balfrclc,
        rtclcmtd,
        uswhpstd,
        orpstddt,
        mctrxstt,
        pstgstus,
        original_je_seq_num,
        voided,
        trxtype,
        revhist,
        trxsorce,
        openyear,
        orcomid,
        exgtblid,
        histrx,
        original_je,
        rvtrxsrc,
        user_defined_text01,
        lastuser,
        exchdate,
        lstdtedt,
        revclyr,
        ortrxsrc,
        glhdrms2,
        original_je_year,
        sqncline,
        time1,
        errstate,
        dtatrxtype,
        refrence,
        series,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
