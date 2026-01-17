with source as (

    select * from {{ source('culc4_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        pstgdate,
        decplacs,
        disttype,
        time1,
        iccurrid,
        mctrxstt,
        expndate,
        dstindx,
        curncyid,
        xchgrate,
        currnidx,
        userid,
        pstgstus,
        orcrdamt,
        interid,
        ratetpid,
        distref,
        changed,
        vendorid,
        rtclcmtd,
        crdtamnt,
        exchdate,
        dex_row_id,
        aptodcty,
        exgtblid,
        trxsorce,
        denxrate,
        ordbtamt,
        correspondingunit,
        debitamt,
        iccurrix,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
