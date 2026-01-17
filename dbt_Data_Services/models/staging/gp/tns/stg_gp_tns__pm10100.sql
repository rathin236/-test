with source as (

    select * from {{ source('tns_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        ratetpid,
        pstgstus,
        dstindx,
        denxrate,
        interid,
        disttype,
        mctrxstt,
        orcrdamt,
        expndate,
        crdtamnt,
        exchdate,
        vendorid,
        pstgdate,
        exgtblid,
        trxsorce,
        decplacs,
        debitamt,
        iccurrix,
        iccurrid,
        correspondingunit,
        ordbtamt,
        changed,
        rtclcmtd,
        xchgrate,
        aptodcty,
        dex_row_id,
        distref,
        curncyid,
        currnidx,
        userid,
        time1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
