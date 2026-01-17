with source as (

    select * from {{ source('cafl_dbo', 'gl10001') }}

),

renamed as (

    select
        jrnentry,
        sqncline,
        currnidx,
        interid,
        exchdate,
        denxrate,
        gllinms2,
        rtclcmtd,
        dex_row_ts,
        orctrnum,
        origseqnum,
        dscriptn,
        accttype,
        dta_gl_status,
        ormstrnm,
        correspondingunit,
        fxdorvar,
        ordocnum,
        crdtamnt,
        pstngtyp,
        dex_row_id,
        lnestat,
        ortrxdesc,
        xchgrate,
        exgtblid,
        gllinmsg,
        gllinval,
        ormstrid,
        mctrxstt,
        bachnumb,
        debitamt,
        decplacs,
        ortrxtyp,
        actindx,
        balfrclc,
        time1,
        ordbtamt,
        orcrdamt,
        ratetpid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
