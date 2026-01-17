with source as (

    select * from {{ source('was_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        vendorid,
        ordbtamt,
        crdtamnt,
        dstindx,
        rtclcmtd,
        pstgdate,
        distref,
        decplacs,
        changed,
        iccurrix,
        disttype,
        curncyid,
        userid,
        iccurrid,
        correspondingunit,
        exchdate,
        dex_row_id,
        orcrdamt,
        ratetpid,
        interid,
        time1,
        xchgrate,
        trxsorce,
        mctrxstt,
        expndate,
        aptodcty,
        debitamt,
        denxrate,
        pstgstus,
        exgtblid,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
