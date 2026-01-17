with source as (

    select * from {{ source('causa_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        time1,
        decplacs,
        denxrate,
        pstgdate,
        iccurrid,
        mctrxstt,
        dstindx,
        expndate,
        curncyid,
        changed,
        crdtamnt,
        debitamt,
        trxsorce,
        correspondingunit,
        iccurrix,
        disttype,
        dex_row_id,
        rtclcmtd,
        ordbtamt,
        vendorid,
        distref,
        aptodcty,
        xchgrate,
        userid,
        exgtblid,
        ratetpid,
        exchdate,
        interid,
        orcrdamt,
        pstgstus,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
