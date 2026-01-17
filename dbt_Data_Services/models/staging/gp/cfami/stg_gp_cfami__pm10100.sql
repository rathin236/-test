with source as (

    select * from {{ source('cfami_dbo', 'pm10100') }}

),

renamed as (

    select
        disttype,
        iccurrid,
        correspondingunit,
        debitamt,
        aptodcty,
        pstgdate,
        denxrate,
        exchdate,
        aptvchnm,
        exgtblid,
        ratetpid,
        decplacs,
        distref,
        userid,
        interid,
        rtclcmtd,
        expndate,
        spcldist,
        vendorid,
        cntrltyp,
        mctrxstt,
        trxsorce,
        iccurrix,
        ordbtamt,
        curncyid,
        dstsqnum,
        dstindx,
        currnidx,
        pstgstus,
        dex_row_id,
        changed,
        xchgrate,
        vchrnmbr,
        crdtamnt,
        orcrdamt,
        time1,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
