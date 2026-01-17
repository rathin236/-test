with source as (

    select * from {{ source('cap_dbo', 'gl10000') }}

),

renamed as (

    select
        bachnumb,
        bchsourc,
        jrnentry,
        closedyr,
        ledger_id,
        exgtblid,
        glhdrmsg,
        glhdrval,
        errstate,
        periodid,
        orcomid,
        tax_date,
        lstdtedt,
        uswhpstd,
        correcting_trx_type,
        rcrngtrx,
        currnidx,
        ratetpid,
        dtacontrolnum,
        revprdid,
        revyear,
        exchdate,
        openyear,
        revclyr,
        series,
        icdists,
        prntstus,
        voided,
        trxdate,
        sqncline,
        orpstddt,
        original_je_year,
        adjustment_transaction,
        balfrclc,
        trxsorce,
        refrence,
        curncyid,
        originje,
        lastuser,
        mctrxstt,
        origdtaseries,
        dtatrxtype,
        trxtype,
        glhdrms2,
        ortrxsrc,
        time1,
        pstgstus,
        rvtrxsrc,
        histrx,
        noteindx,
        rtclcmtd,
        original_je_seq_num,
        xchgrate,
        original_je,
        user_defined_text02,
        denxrate,
        rvrsngdt,
        dta_index,
        dex_row_ts,
        dex_row_id,
        ictrx,
        user_defined_text01,
        sourcdoc,
        revhist,
        docdate,
        rctrxseq,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
