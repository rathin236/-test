with source as (

    select * from {{ source('cap_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        accttype,
        gllinms2,
        interid,
        time1,
        balfrclc,
        debitamt,
        actindx,
        currnidx,
        ormstrnm,
        ordocnum,
        mctrxstt,
        exchdate,
        denxrate,
        correspondingunit,
        orctrnum,
        exgtblid,
        crdtamnt,
        gllinmsg,
        gllinval,
        ortrxtyp,
        origseqnum,
        dta_gl_status,
        ortrxdesc,
        dex_row_ts,
        ormstrid,
        ratetpid,
        ordbtamt,
        orcrdamt,
        decplacs,
        xchgrate,
        pstngtyp,
        lnestat,
        rtclcmtd,
        dex_row_id,
        bachnumb,
        fxdorvar,
        dscriptn,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
