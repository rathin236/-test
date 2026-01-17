with source as (

    select * from {{ source('gmg_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        fxdorvar,
        exchdate,
        gllinmsg,
        dta_gl_status,
        debitamt,
        gllinval,
        crdtamnt,
        rtclcmtd,
        dscriptn,
        xchgrate,
        ortrxdesc,
        gllinms2,
        ratetpid,
        dex_row_ts,
        dex_row_id,
        ormstrid,
        decplacs,
        ortrxtyp,
        balfrclc,
        bachnumb,
        ordocnum,
        orctrnum,
        origseqnum,
        actindx,
        mctrxstt,
        denxrate,
        interid,
        lnestat,
        pstngtyp,
        exgtblid,
        time1,
        correspondingunit,
        ordbtamt,
        orcrdamt,
        currnidx,
        accttype,
        ormstrnm,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
