with source as (

    select * from {{ source('hpi_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        ormstrid,
        exgtblid,
        bachnumb,
        exchdate,
        origseqnum,
        mctrxstt,
        gllinms2,
        actindx,
        time1,
        denxrate,
        decplacs,
        ratetpid,
        balfrclc,
        ortrxtyp,
        ortrxdesc,
        crdtamnt,
        debitamt,
        lnestat,
        currnidx,
        interid,
        rtclcmtd,
        orctrnum,
        dscriptn,
        gllinmsg,
        gllinval,
        xchgrate,
        dta_gl_status,
        fxdorvar,
        dex_row_id,
        dex_row_ts,
        ormstrnm,
        correspondingunit,
        accttype,
        ordbtamt,
        orcrdamt,
        ordocnum,
        pstngtyp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
