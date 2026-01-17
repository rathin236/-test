with source as (

    select * from {{ source('culc4_dbo', 'gl10001') }}

),

renamed as (

    select
        dex_row_ts,
        pstngtyp,
        interid,
        decplacs,
        ordbtamt,
        orcrdamt,
        exchdate,
        gllinms2,
        lnestat,
        rtclcmtd,
        sqncline,
        ortrxtyp,
        dscriptn,
        currnidx,
        orctrnum,
        dex_row_id,
        ortrxdesc,
        mctrxstt,
        denxrate,
        origseqnum,
        ratetpid,
        crdtamnt,
        ormstrid,
        debitamt,
        correspondingunit,
        accttype,
        exgtblid,
        bachnumb,
        balfrclc,
        ordocnum,
        ormstrnm,
        actindx,
        gllinmsg,
        jrnentry,
        xchgrate,
        gllinval,
        dta_gl_status,
        time1,
        fxdorvar,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
