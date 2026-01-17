with source as (

    select * from {{ source('tnsc_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        interid,
        exchdate,
        ordbtamt,
        orcrdamt,
        lnestat,
        gllinms2,
        origseqnum,
        ortrxtyp,
        decplacs,
        denxrate,
        time1,
        rtclcmtd,
        dscriptn,
        bachnumb,
        balfrclc,
        crdtamnt,
        dex_row_id,
        ortrxdesc,
        ormstrid,
        ratetpid,
        exgtblid,
        fxdorvar,
        dta_gl_status,
        debitamt,
        mctrxstt,
        xchgrate,
        accttype,
        gllinmsg,
        ordocnum,
        gllinval,
        orctrnum,
        pstngtyp,
        actindx,
        dex_row_ts,
        correspondingunit,
        currnidx,
        ormstrnm,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
