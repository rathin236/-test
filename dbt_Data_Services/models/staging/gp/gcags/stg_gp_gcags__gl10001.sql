with source as (

    select * from {{ source('gcags_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        xchgrate,
        ratetpid,
        currnidx,
        lnestat,
        rtclcmtd,
        pstngtyp,
        correspondingunit,
        origseqnum,
        exgtblid,
        decplacs,
        accttype,
        ordocnum,
        dex_row_id,
        debitamt,
        ormstrnm,
        fxdorvar,
        dta_gl_status,
        time1,
        ordbtamt,
        orcrdamt,
        denxrate,
        dscriptn,
        exchdate,
        dex_row_ts,
        mctrxstt,
        interid,
        balfrclc,
        orctrnum,
        bachnumb,
        gllinmsg,
        gllinval,
        ortrxtyp,
        ormstrid,
        gllinms2,
        crdtamnt,
        actindx,
        ortrxdesc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
