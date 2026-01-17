with source as (

    select * from {{ source('cagsf_dbo', 'gl10001') }}

),

renamed as (

    select
        ormstrid,
        exgtblid,
        pstngtyp,
        rtclcmtd,
        jrnentry,
        ortrxdesc,
        bachnumb,
        sqncline,
        gllinms2,
        currnidx,
        xchgrate,
        decplacs,
        ratetpid,
        time1,
        origseqnum,
        fxdorvar,
        dta_gl_status,
        gllinmsg,
        accttype,
        dscriptn,
        actindx,
        ordbtamt,
        orcrdamt,
        lnestat,
        mctrxstt,
        interid,
        balfrclc,
        crdtamnt,
        gllinval,
        ordocnum,
        debitamt,
        denxrate,
        dex_row_ts,
        correspondingunit,
        ormstrnm,
        orctrnum,
        ortrxtyp,
        exchdate,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
