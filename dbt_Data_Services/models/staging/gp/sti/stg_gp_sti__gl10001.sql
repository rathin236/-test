with source as (

    select * from {{ source('sti_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        balfrclc,
        ortrxdesc,
        mctrxstt,
        bachnumb,
        accttype,
        time1,
        correspondingunit,
        xchgrate,
        ormstrid,
        ratetpid,
        dex_row_id,
        gllinmsg,
        debitamt,
        currnidx,
        lnestat,
        gllinms2,
        pstngtyp,
        interid,
        decplacs,
        dscriptn,
        dex_row_ts,
        actindx,
        gllinval,
        rtclcmtd,
        exchdate,
        crdtamnt,
        dta_gl_status,
        denxrate,
        fxdorvar,
        ordocnum,
        origseqnum,
        ormstrnm,
        exgtblid,
        ordbtamt,
        orcrdamt,
        orctrnum,
        ortrxtyp,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
