with source as (

    select * from {{ source('hsi_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        disttype,
        mctrxstt,
        exgtblid,
        userid,
        trxsorce,
        decplacs,
        vendorid,
        distref,
        time1,
        dex_row_id,
        ratetpid,
        pstgdate,
        exchdate,
        xchgrate,
        expndate,
        pstgstus,
        curncyid,
        currnidx,
        orcrdamt,
        aptodcty,
        changed,
        denxrate,
        correspondingunit,
        interid,
        crdtamnt,
        iccurrid,
        debitamt,
        dstindx,
        iccurrix,
        ordbtamt,
        rtclcmtd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
