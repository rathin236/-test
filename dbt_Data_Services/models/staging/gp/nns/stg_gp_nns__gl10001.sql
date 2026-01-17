with source as (

    select * from {{ source('nns_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        denxrate,
        ormstrid,
        ortrxdesc,
        bachnumb,
        balfrclc,
        time1,
        ortrxtyp,
        ratetpid,
        origseqnum,
        decplacs,
        crdtamnt,
        exgtblid,
        fxdorvar,
        interid,
        dta_gl_status,
        actindx,
        ordocnum,
        xchgrate,
        currnidx,
        orctrnum,
        lnestat,
        rtclcmtd,
        pstngtyp,
        ordbtamt,
        orcrdamt,
        correspondingunit,
        ormstrnm,
        debitamt,
        dex_row_ts,
        accttype,
        dscriptn,
        exchdate,
        mctrxstt,
        dex_row_id,
        gllinmsg,
        gllinms2,
        gllinval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
