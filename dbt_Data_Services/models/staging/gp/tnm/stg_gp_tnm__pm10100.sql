with source as (

    select * from {{ source('tnm_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        aptodcty,
        debitamt,
        interid,
        xchgrate,
        ordbtamt,
        dstindx,
        curncyid,
        pstgstus,
        userid,
        exchdate,
        distref,
        ratetpid,
        currnidx,
        denxrate,
        time1,
        decplacs,
        expndate,
        mctrxstt,
        crdtamnt,
        pstgdate,
        orcrdamt,
        changed,
        exgtblid,
        trxsorce,
        iccurrix,
        dex_row_id,
        vendorid,
        rtclcmtd,
        disttype,
        iccurrid,
        correspondingunit,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
