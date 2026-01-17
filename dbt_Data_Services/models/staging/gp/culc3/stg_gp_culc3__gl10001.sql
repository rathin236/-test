with source as (

    select * from {{ source('culc3_dbo', 'gl10001') }}

),

renamed as (

    select
        gllinms2,
        jrnentry,
        denxrate,
        decplacs,
        actindx,
        rtclcmtd,
        crdtamnt,
        fxdorvar,
        dta_gl_status,
        ormstrid,
        bachnumb,
        origseqnum,
        debitamt,
        ratetpid,
        ortrxdesc,
        exgtblid,
        lnestat,
        currnidx,
        dex_row_ts,
        xchgrate,
        pstngtyp,
        gllinval,
        dex_row_id,
        interid,
        gllinmsg,
        balfrclc,
        mctrxstt,
        ordocnum,
        orctrnum,
        accttype,
        sqncline,
        exchdate,
        orcrdamt,
        ordbtamt,
        correspondingunit,
        ormstrnm,
        dscriptn,
        time1,
        ortrxtyp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
