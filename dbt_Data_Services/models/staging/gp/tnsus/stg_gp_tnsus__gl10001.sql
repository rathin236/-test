with source as (

    select * from {{ source('tnsus_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        decplacs,
        ortrxtyp,
        crdtamnt,
        exchdate,
        dta_gl_status,
        dex_row_ts,
        rtclcmtd,
        debitamt,
        time1,
        exgtblid,
        denxrate,
        mctrxstt,
        origseqnum,
        actindx,
        ordocnum,
        gllinmsg,
        gllinms2,
        ormstrnm,
        correspondingunit,
        gllinval,
        ordbtamt,
        orcrdamt,
        orctrnum,
        balfrclc,
        xchgrate,
        accttype,
        ormstrid,
        bachnumb,
        currnidx,
        interid,
        ortrxdesc,
        dex_row_id,
        pstngtyp,
        dscriptn,
        fxdorvar,
        ratetpid,
        lnestat,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
