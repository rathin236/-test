with source as (

    select * from {{ source('tnsc_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        iccurrix,
        pstgstus,
        debitamt,
        xchgrate,
        iccurrid,
        correspondingunit,
        dex_row_id,
        ratetpid,
        pstgdate,
        time1,
        interid,
        aptodcty,
        mctrxstt,
        exchdate,
        changed,
        currnidx,
        expndate,
        curncyid,
        userid,
        orcrdamt,
        dstindx,
        crdtamnt,
        vendorid,
        distref,
        denxrate,
        trxsorce,
        exgtblid,
        decplacs,
        rtclcmtd,
        disttype,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
