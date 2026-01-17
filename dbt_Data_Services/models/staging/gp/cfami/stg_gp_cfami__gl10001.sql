with source as (

    select * from {{ source('cfami_dbo', 'gl10001') }}

),

renamed as (

    select
        correspondingunit,
        dta_gl_status,
        lnestat,
        decplacs,
        gllinms2,
        exchdate,
        sqncline,
        ormstrid,
        fxdorvar,
        dex_row_id,
        currnidx,
        dscriptn,
        ordocnum,
        mctrxstt,
        actindx,
        exgtblid,
        ratetpid,
        balfrclc,
        accttype,
        jrnentry,
        ordbtamt,
        crdtamnt,
        ortrxtyp,
        origseqnum,
        orcrdamt,
        rtclcmtd,
        orctrnum,
        denxrate,
        ortrxdesc,
        dex_row_ts,
        gllinmsg,
        debitamt,
        xchgrate,
        time1,
        ormstrnm,
        pstngtyp,
        bachnumb,
        gllinval,
        interid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
