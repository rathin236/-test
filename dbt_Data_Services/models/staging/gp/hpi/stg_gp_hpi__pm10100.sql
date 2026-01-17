with source as (

    select * from {{ source('hpi_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        changed,
        xchgrate,
        debitamt,
        expndate,
        curncyid,
        userid,
        aptodcty,
        ratetpid,
        pstgdate,
        orcrdamt,
        currnidx,
        distref,
        exchdate,
        correspondingunit,
        interid,
        pstgstus,
        iccurrix,
        mctrxstt,
        denxrate,
        dstindx,
        dex_row_id,
        trxsorce,
        exgtblid,
        disttype,
        decplacs,
        crdtamnt,
        ordbtamt,
        time1,
        iccurrid,
        rtclcmtd,
        vendorid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
