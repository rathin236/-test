with source as (

    select * from {{ source('cpqln_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        userid,
        orcrdamt,
        trxsorce,
        exgtblid,
        time1,
        denxrate,
        expndate,
        pstgdate,
        ratetpid,
        vendorid,
        distref,
        mctrxstt,
        dex_row_id,
        iccurrid,
        correspondingunit,
        interid,
        rtclcmtd,
        disttype,
        decplacs,
        debitamt,
        iccurrix,
        currnidx,
        changed,
        aptodcty,
        ordbtamt,
        crdtamnt,
        xchgrate,
        dstindx,
        pstgstus,
        exchdate,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
