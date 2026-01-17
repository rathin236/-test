with source as (

    select * from {{ source('rbf_dbo', 'gl10001') }}

),

renamed as (

    select
        ormstrnm,
        rtclcmtd,
        pstngtyp,
        correspondingunit,
        dex_row_id,
        currnidx,
        ortrxtyp,
        debitamt,
        ordocnum,
        ratetpid,
        origseqnum,
        time1,
        lnestat,
        gllinval,
        dex_row_ts,
        interid,
        exgtblid,
        dta_gl_status,
        fxdorvar,
        decplacs,
        orctrnum,
        denxrate,
        crdtamnt,
        balfrclc,
        actindx,
        ordbtamt,
        orcrdamt,
        mctrxstt,
        xchgrate,
        sqncline,
        gllinms2,
        gllinmsg,
        ortrxdesc,
        bachnumb,
        jrnentry,
        ormstrid,
        accttype,
        dscriptn,
        exchdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
