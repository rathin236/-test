with source as (

    select * from {{ source('tnscl_dbo', 'gl10001') }}

),

renamed as (

    select
        gllinmsg,
        ordocnum,
        dex_row_id,
        accttype,
        orctrnum,
        ormstrnm,
        dex_row_ts,
        mctrxstt,
        balfrclc,
        debitamt,
        xchgrate,
        origseqnum,
        gllinval,
        ordbtamt,
        orcrdamt,
        currnidx,
        exchdate,
        correspondingunit,
        pstngtyp,
        lnestat,
        decplacs,
        ortrxtyp,
        time1,
        dta_gl_status,
        fxdorvar,
        gllinms2,
        denxrate,
        rtclcmtd,
        exgtblid,
        jrnentry,
        ratetpid,
        interid,
        sqncline,
        ortrxdesc,
        crdtamnt,
        dscriptn,
        bachnumb,
        actindx,
        ormstrid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
