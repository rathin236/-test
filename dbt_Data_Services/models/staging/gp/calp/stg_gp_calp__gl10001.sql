with source as (

    select * from {{ source('calp_dbo', 'gl10001') }}

),

renamed as (

    select
        dscriptn,
        gllinval,
        time1,
        actindx,
        gllinmsg,
        interid,
        mctrxstt,
        ormstrid,
        orcrdamt,
        bachnumb,
        ordbtamt,
        currnidx,
        accttype,
        ratetpid,
        rtclcmtd,
        dex_row_id,
        pstngtyp,
        gllinms2,
        lnestat,
        dex_row_ts,
        debitamt,
        origseqnum,
        crdtamnt,
        ortrxdesc,
        dta_gl_status,
        fxdorvar,
        ordocnum,
        denxrate,
        xchgrate,
        exchdate,
        jrnentry,
        orctrnum,
        ormstrnm,
        exgtblid,
        sqncline,
        correspondingunit,
        decplacs,
        ortrxtyp,
        balfrclc,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
