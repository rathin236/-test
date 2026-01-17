with source as (

    select * from {{ source('nni_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        dta_gl_status,
        fxdorvar,
        exchdate,
        debitamt,
        mctrxstt,
        exgtblid,
        pstngtyp,
        currnidx,
        ordocnum,
        denxrate,
        correspondingunit,
        dex_row_ts,
        ormstrnm,
        crdtamnt,
        accttype,
        dex_row_id,
        origseqnum,
        gllinms2,
        orctrnum,
        lnestat,
        gllinmsg,
        balfrclc,
        ortrxdesc,
        interid,
        xchgrate,
        dscriptn,
        ortrxtyp,
        ordbtamt,
        orcrdamt,
        time1,
        gllinval,
        ratetpid,
        decplacs,
        bachnumb,
        actindx,
        ormstrid,
        rtclcmtd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
