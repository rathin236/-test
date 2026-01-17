with source as (

    select * from {{ source('nb678_dbo', 'gl10001') }}

),

renamed as (

    select
        mctrxstt,
        balfrclc,
        ordbtamt,
        orcrdamt,
        correspondingunit,
        ormstrnm,
        ratetpid,
        xchgrate,
        ordocnum,
        sqncline,
        origseqnum,
        ortrxdesc,
        jrnentry,
        gllinms2,
        fxdorvar,
        exchdate,
        interid,
        gllinval,
        accttype,
        orctrnum,
        dex_row_ts,
        currnidx,
        dex_row_id,
        pstngtyp,
        exgtblid,
        lnestat,
        time1,
        gllinmsg,
        rtclcmtd,
        decplacs,
        dta_gl_status,
        debitamt,
        ormstrid,
        actindx,
        bachnumb,
        ortrxtyp,
        dscriptn,
        denxrate,
        crdtamnt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
