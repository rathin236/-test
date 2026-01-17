with source as (

    select * from {{ source('stusa_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        ordbtamt,
        orcrdamt,
        pstngtyp,
        ortrxtyp,
        dta_gl_status,
        exgtblid,
        ormstrid,
        rtclcmtd,
        dex_row_id,
        xchgrate,
        bachnumb,
        gllinmsg,
        gllinval,
        decplacs,
        ratetpid,
        time1,
        currnidx,
        ortrxdesc,
        denxrate,
        actindx,
        lnestat,
        fxdorvar,
        origseqnum,
        interid,
        orctrnum,
        crdtamnt,
        ordocnum,
        balfrclc,
        exchdate,
        mctrxstt,
        gllinms2,
        accttype,
        debitamt,
        correspondingunit,
        ormstrnm,
        dscriptn,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
