with source as (

    select * from {{ source('aaa_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        interid,
        ortrxtyp,
        decplacs,
        xchgrate,
        pstngtyp,
        dscriptn,
        lnestat,
        orctrnum,
        fxdorvar,
        dta_gl_status,
        orcrdamt,
        ordbtamt,
        dex_row_id,
        debitamt,
        time1,
        ratetpid,
        rtclcmtd,
        balfrclc,
        ormstrid,
        bachnumb,
        ortrxdesc,
        exgtblid,
        exchdate,
        dex_row_ts,
        origseqnum,
        actindx,
        mctrxstt,
        crdtamnt,
        correspondingunit,
        ormstrnm,
        gllinmsg,
        gllinval,
        currnidx,
        accttype,
        denxrate,
        ordocnum,
        gllinms2,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
