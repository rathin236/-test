with source as (

    select * from {{ source('ci_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        ortrxtyp,
        bachnumb,
        orctrnum,
        interid,
        correspondingunit,
        dex_row_id,
        pstngtyp,
        ormstrnm,
        xchgrate,
        gllinmsg,
        actindx,
        origseqnum,
        dscriptn,
        ormstrid,
        gllinval,
        dta_gl_status,
        decplacs,
        lnestat,
        ratetpid,
        dex_row_ts,
        fxdorvar,
        gllinms2,
        time1,
        ordocnum,
        currnidx,
        ordbtamt,
        mctrxstt,
        crdtamnt,
        exgtblid,
        orcrdamt,
        rtclcmtd,
        denxrate,
        ortrxdesc,
        accttype,
        balfrclc,
        debitamt,
        exchdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
