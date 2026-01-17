with source as (

    select * from {{ source('hsi_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        gllinmsg,
        denxrate,
        correspondingunit,
        ormstrnm,
        decplacs,
        origseqnum,
        fxdorvar,
        gllinval,
        ordocnum,
        ratetpid,
        dta_gl_status,
        ormstrid,
        exchdate,
        bachnumb,
        ortrxdesc,
        rtclcmtd,
        ortrxtyp,
        actindx,
        dscriptn,
        time1,
        crdtamnt,
        xchgrate,
        balfrclc,
        accttype,
        mctrxstt,
        debitamt,
        interid,
        exgtblid,
        ordbtamt,
        orcrdamt,
        gllinms2,
        orctrnum,
        lnestat,
        dex_row_id,
        currnidx,
        pstngtyp,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
