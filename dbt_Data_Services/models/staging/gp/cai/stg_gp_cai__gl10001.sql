with source as (

    select * from {{ source('cai_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        mctrxstt,
        dscriptn,
        interid,
        orcrdamt,
        ordbtamt,
        denxrate,
        exgtblid,
        time1,
        ordocnum,
        exchdate,
        ormstrnm,
        accttype,
        debitamt,
        rtclcmtd,
        lnestat,
        correspondingunit,
        dex_row_id,
        currnidx,
        pstngtyp,
        origseqnum,
        crdtamnt,
        orctrnum,
        fxdorvar,
        bachnumb,
        ortrxdesc,
        gllinmsg,
        dta_gl_status,
        ortrxtyp,
        dex_row_ts,
        gllinval,
        gllinms2,
        balfrclc,
        ratetpid,
        xchgrate,
        ormstrid,
        actindx,
        decplacs,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
