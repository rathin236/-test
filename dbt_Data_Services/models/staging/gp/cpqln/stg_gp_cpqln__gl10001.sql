with source as (

    select * from {{ source('cpqln_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        ormstrnm,
        fxdorvar,
        xchgrate,
        ordocnum,
        dta_gl_status,
        correspondingunit,
        decplacs,
        ortrxtyp,
        ratetpid,
        ordbtamt,
        orcrdamt,
        exchdate,
        gllinms2,
        interid,
        lnestat,
        debitamt,
        pstngtyp,
        actindx,
        orctrnum,
        exgtblid,
        dex_row_ts,
        denxrate,
        gllinmsg,
        origseqnum,
        currnidx,
        gllinval,
        balfrclc,
        accttype,
        rtclcmtd,
        ortrxdesc,
        mctrxstt,
        bachnumb,
        crdtamnt,
        dex_row_id,
        ormstrid,
        dscriptn,
        time1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
