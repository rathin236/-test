with source as (

    select * from {{ source('ci_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        dex_row_id,
        denxrate,
        time1,
        iccurrid,
        rtclcmtd,
        pstgstus,
        userid,
        distref,
        exchdate,
        disttype,
        interid,
        iccurrix,
        expndate,
        vendorid,
        ordbtamt,
        correspondingunit,
        decplacs,
        currnidx,
        trxsorce,
        pstgdate,
        exgtblid,
        changed,
        ratetpid,
        curncyid,
        xchgrate,
        crdtamnt,
        orcrdamt,
        aptodcty,
        mctrxstt,
        dstindx,
        debitamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
