with source as (

    select * from {{ source('causa_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        dscriptn,
        pstngtyp,
        xchgrate,
        rtclcmtd,
        debitamt,
        decplacs,
        dta_gl_status,
        actindx,
        dex_row_ts,
        ordbtamt,
        orcrdamt,
        fxdorvar,
        ordocnum,
        currnidx,
        exchdate,
        lnestat,
        ratetpid,
        mctrxstt,
        dex_row_id,
        balfrclc,
        origseqnum,
        ormstrid,
        accttype,
        exgtblid,
        correspondingunit,
        ormstrnm,
        bachnumb,
        time1,
        crdtamnt,
        orctrnum,
        gllinms2,
        ortrxdesc,
        denxrate,
        ortrxtyp,
        interid,
        gllinmsg,
        gllinval,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
