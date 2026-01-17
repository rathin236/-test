with source as (

    select * from {{ source('nb601_dbo', 'pm10100') }}

),

renamed as (

    select
        aptodcty,
        cntrltyp,
        mctrxstt,
        curncyid,
        pstgdate,
        ordbtamt,
        exchdate,
        vchrnmbr,
        expndate,
        pstgstus,
        crdtamnt,
        dstindx,
        xchgrate,
        iccurrid,
        dex_row_id,
        correspondingunit,
        orcrdamt,
        debitamt,
        disttype,
        denxrate,
        userid,
        exgtblid,
        aptvchnm,
        iccurrix,
        distref,
        ratetpid,
        decplacs,
        interid,
        currnidx,
        vendorid,
        rtclcmtd,
        time1,
        dstsqnum,
        spcldist,
        changed,
        trxsorce,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
