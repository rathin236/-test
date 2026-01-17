with source as (

    select * from {{ source('nb601_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        fxdorvar,
        ortrxdesc,
        currnidx,
        ordbtamt,
        mctrxstt,
        gllinms2,
        ormstrnm,
        rtclcmtd,
        exchdate,
        bachnumb,
        xchgrate,
        accttype,
        balfrclc,
        correspondingunit,
        interid,
        ortrxtyp,
        ormstrid,
        dscriptn,
        ordocnum,
        pstngtyp,
        exgtblid,
        dex_row_id,
        ratetpid,
        gllinmsg,
        crdtamnt,
        origseqnum,
        dex_row_ts,
        orcrdamt,
        actindx,
        lnestat,
        decplacs,
        time1,
        gllinval,
        dta_gl_status,
        denxrate,
        orctrnum,
        debitamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
