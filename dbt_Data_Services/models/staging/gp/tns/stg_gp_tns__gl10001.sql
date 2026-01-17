with source as (

    select * from {{ source('tns_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        rtclcmtd,
        orctrnum,
        lnestat,
        pstngtyp,
        interid,
        decplacs,
        ortrxtyp,
        currnidx,
        fxdorvar,
        dta_gl_status,
        correspondingunit,
        exchdate,
        debitamt,
        xchgrate,
        ormstrnm,
        dex_row_id,
        gllinms2,
        gllinmsg,
        gllinval,
        ordocnum,
        bachnumb,
        time1,
        exgtblid,
        accttype,
        balfrclc,
        ordbtamt,
        orcrdamt,
        dscriptn,
        crdtamnt,
        dex_row_ts,
        origseqnum,
        ortrxdesc,
        denxrate,
        ormstrid,
        mctrxstt,
        actindx,
        ratetpid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
