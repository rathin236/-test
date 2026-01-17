with source as (

    select * from {{ source('casl_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        interid,
        rtclcmtd,
        lnestat,
        dscriptn,
        crdtamnt,
        orctrnum,
        time1,
        debitamt,
        denxrate,
        currnidx,
        pstngtyp,
        ortrxtyp,
        dex_row_id,
        gllinms2,
        accttype,
        gllinmsg,
        ordbtamt,
        orcrdamt,
        gllinval,
        ormstrid,
        ratetpid,
        mctrxstt,
        exchdate,
        ortrxdesc,
        bachnumb,
        xchgrate,
        actindx,
        balfrclc,
        exgtblid,
        dex_row_ts,
        ormstrnm,
        fxdorvar,
        decplacs,
        origseqnum,
        correspondingunit,
        ordocnum,
        dta_gl_status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
