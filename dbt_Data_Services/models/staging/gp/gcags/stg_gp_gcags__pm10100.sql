with source as (

    select * from {{ source('gcags_dbo', 'pm10100') }}

),

renamed as (

    select
        pstgstus,
        vendorid,
        distref,
        orcrdamt,
        changed,
        denxrate,
        exchdate,
        vchrnmbr,
        mctrxstt,
        dex_row_id,
        cntrltyp,
        debitamt,
        disttype,
        exgtblid,
        crdtamnt,
        dstindx,
        decplacs,
        correspondingunit,
        ordbtamt,
        trxsorce,
        rtclcmtd,
        iccurrid,
        iccurrix,
        dstsqnum,
        pstgdate,
        aptvchnm,
        spcldist,
        curncyid,
        interid,
        expndate,
        ratetpid,
        aptodcty,
        xchgrate,
        userid,
        currnidx,
        time1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
