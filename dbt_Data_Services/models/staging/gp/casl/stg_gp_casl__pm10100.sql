with source as (

    select * from {{ source('casl_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        iccurrid,
        interid,
        dex_row_id,
        pstgstus,
        iccurrix,
        decplacs,
        mctrxstt,
        currnidx,
        disttype,
        changed,
        userid,
        ordbtamt,
        ratetpid,
        curncyid,
        distref,
        crdtamnt,
        pstgdate,
        rtclcmtd,
        vendorid,
        exchdate,
        denxrate,
        dstindx,
        aptodcty,
        debitamt,
        expndate,
        exgtblid,
        orcrdamt,
        time1,
        xchgrate,
        correspondingunit,
        trxsorce,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
