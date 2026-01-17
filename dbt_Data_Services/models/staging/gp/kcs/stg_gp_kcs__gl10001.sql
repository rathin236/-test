with source as (

    select * from {{ source('kcs_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        bachnumb,
        gllinval,
        ormstrid,
        exgtblid,
        origseqnum,
        dta_gl_status,
        pstngtyp,
        ortrxtyp,
        time1,
        rtclcmtd,
        gllinmsg,
        decplacs,
        xchgrate,
        currnidx,
        fxdorvar,
        exchdate,
        lnestat,
        ortrxdesc,
        ordbtamt,
        orcrdamt,
        dex_row_id,
        ratetpid,
        balfrclc,
        interid,
        mctrxstt,
        dex_row_ts,
        dscriptn,
        accttype,
        orctrnum,
        debitamt,
        gllinms2,
        correspondingunit,
        ormstrnm,
        denxrate,
        crdtamnt,
        actindx,
        ordocnum,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
