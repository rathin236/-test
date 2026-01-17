with source as (

    select * from {{ source('culc1_dbo', 'gl10001') }}

),

renamed as (

    select
        ortrxdesc,
        exgtblid,
        decplacs,
        ratetpid,
        fxdorvar,
        correspondingunit,
        debitamt,
        gllinmsg,
        gllinval,
        ormstrid,
        dta_gl_status,
        bachnumb,
        jrnentry,
        orctrnum,
        origseqnum,
        rtclcmtd,
        actindx,
        time1,
        ortrxtyp,
        interid,
        dscriptn,
        balfrclc,
        ordbtamt,
        orcrdamt,
        accttype,
        dex_row_id,
        xchgrate,
        exchdate,
        sqncline,
        mctrxstt,
        dex_row_ts,
        ormstrnm,
        ordocnum,
        gllinms2,
        lnestat,
        crdtamnt,
        currnidx,
        pstngtyp,
        denxrate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
