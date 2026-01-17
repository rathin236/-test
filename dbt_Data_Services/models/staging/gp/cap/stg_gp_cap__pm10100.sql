with source as (

    select * from {{ source('cap_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        iccurrid,
        aptodcty,
        correspondingunit,
        crdtamnt,
        rtclcmtd,
        dstindx,
        interid,
        currnidx,
        ratetpid,
        pstgstus,
        xchgrate,
        trxsorce,
        orcrdamt,
        changed,
        pstgdate,
        exgtblid,
        time1,
        expndate,
        mctrxstt,
        debitamt,
        decplacs,
        dex_row_id,
        denxrate,
        disttype,
        vendorid,
        distref,
        ordbtamt,
        exchdate,
        userid,
        iccurrix,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
