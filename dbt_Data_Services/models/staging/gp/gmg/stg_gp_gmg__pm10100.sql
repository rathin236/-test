with source as (

    select * from {{ source('gmg_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        changed,
        time1,
        pstgdate,
        decplacs,
        pstgstus,
        dstindx,
        distref,
        orcrdamt,
        denxrate,
        mctrxstt,
        dex_row_id,
        userid,
        curncyid,
        aptodcty,
        xchgrate,
        trxsorce,
        ordbtamt,
        currnidx,
        debitamt,
        ratetpid,
        iccurrix,
        interid,
        vendorid,
        iccurrid,
        correspondingunit,
        rtclcmtd,
        disttype,
        crdtamnt,
        exgtblid,
        exchdate,
        expndate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
