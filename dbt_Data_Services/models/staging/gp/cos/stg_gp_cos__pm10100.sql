with source as (

    select * from {{ source('cos_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        decplacs,
        mctrxstt,
        time1,
        changed,
        pstgdate,
        crdtamnt,
        distref,
        userid,
        pstgstus,
        curncyid,
        currnidx,
        rtclcmtd,
        ratetpid,
        debitamt,
        aptodcty,
        interid,
        xchgrate,
        orcrdamt,
        ordbtamt,
        exchdate,
        vendorid,
        iccurrix,
        dex_row_id,
        dstindx,
        expndate,
        trxsorce,
        exgtblid,
        iccurrid,
        correspondingunit,
        disttype,
        denxrate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
