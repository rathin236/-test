with source as (

    select * from {{ source('tfc_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        bachnumb,
        gllinval,
        ormstrid,
        ortrxdesc,
        crdtamnt,
        denxrate,
        accttype,
        exgtblid,
        time1,
        pstngtyp,
        ratetpid,
        exchdate,
        dscriptn,
        currnidx,
        lnestat,
        gllinms2,
        fxdorvar,
        orctrnum,
        decplacs,
        dta_gl_status,
        dex_row_id,
        interid,
        ordbtamt,
        orcrdamt,
        correspondingunit,
        dex_row_ts,
        balfrclc,
        mctrxstt,
        actindx,
        rtclcmtd,
        ortrxtyp,
        gllinmsg,
        ordocnum,
        debitamt,
        xchgrate,
        ormstrnm,
        origseqnum,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
