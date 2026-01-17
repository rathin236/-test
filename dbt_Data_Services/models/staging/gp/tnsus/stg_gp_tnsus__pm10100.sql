with source as (

    select * from {{ source('tnsus_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        crdtamnt,
        disttype,
        mctrxstt,
        correspondingunit,
        dex_row_id,
        time1,
        iccurrid,
        currnidx,
        vendorid,
        changed,
        xchgrate,
        expndate,
        pstgstus,
        orcrdamt,
        aptodcty,
        debitamt,
        userid,
        trxsorce,
        exgtblid,
        exchdate,
        distref,
        ratetpid,
        denxrate,
        dstindx,
        iccurrix,
        interid,
        pstgdate,
        rtclcmtd,
        curncyid,
        decplacs,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
