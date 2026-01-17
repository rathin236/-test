with source as (

    select * from {{ source('cos_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        gllinval,
        actindx,
        crdtamnt,
        rtclcmtd,
        decplacs,
        exgtblid,
        dta_gl_status,
        origseqnum,
        dscriptn,
        ratetpid,
        ormstrid,
        denxrate,
        dex_row_ts,
        ortrxdesc,
        bachnumb,
        ortrxtyp,
        gllinmsg,
        gllinms2,
        orctrnum,
        balfrclc,
        ordbtamt,
        ordocnum,
        mctrxstt,
        accttype,
        interid,
        orcrdamt,
        exchdate,
        fxdorvar,
        currnidx,
        debitamt,
        lnestat,
        ormstrnm,
        time1,
        xchgrate,
        pstngtyp,
        correspondingunit,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
