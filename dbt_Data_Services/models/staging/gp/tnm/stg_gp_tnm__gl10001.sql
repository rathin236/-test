with source as (

    select * from {{ source('tnm_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        accttype,
        interid,
        gllinmsg,
        orctrnum,
        ordbtamt,
        mctrxstt,
        dscriptn,
        orcrdamt,
        xchgrate,
        gllinms2,
        gllinval,
        rtclcmtd,
        balfrclc,
        ortrxtyp,
        ratetpid,
        time1,
        debitamt,
        origseqnum,
        ortrxdesc,
        exgtblid,
        ormstrid,
        bachnumb,
        decplacs,
        crdtamnt,
        fxdorvar,
        exchdate,
        dta_gl_status,
        dex_row_id,
        currnidx,
        denxrate,
        actindx,
        ormstrnm,
        lnestat,
        correspondingunit,
        pstngtyp,
        ordocnum,
        dex_row_ts,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
