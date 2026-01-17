with source as (

    select * from {{ source('stusa_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        exchdate,
        debitamt,
        disttype,
        changed,
        curncyid,
        denxrate,
        mctrxstt,
        distref,
        dex_row_id,
        pstgdate,
        xchgrate,
        iccurrix,
        interid,
        orcrdamt,
        decplacs,
        crdtamnt,
        rtclcmtd,
        ratetpid,
        correspondingunit,
        exgtblid,
        trxsorce,
        expndate,
        dstindx,
        aptodcty,
        userid,
        vendorid,
        currnidx,
        iccurrid,
        time1,
        pstgstus,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
