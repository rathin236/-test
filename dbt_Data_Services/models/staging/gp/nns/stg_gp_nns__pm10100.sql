with source as (

    select * from {{ source('nns_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        dex_row_id,
        crdtamnt,
        rtclcmtd,
        curncyid,
        ordbtamt,
        xchgrate,
        aptodcty,
        distref,
        time1,
        expndate,
        decplacs,
        mctrxstt,
        interid,
        iccurrix,
        exchdate,
        pstgstus,
        orcrdamt,
        denxrate,
        ratetpid,
        dstindx,
        correspondingunit,
        exgtblid,
        userid,
        iccurrid,
        currnidx,
        trxsorce,
        disttype,
        vendorid,
        changed,
        pstgdate,
        debitamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
