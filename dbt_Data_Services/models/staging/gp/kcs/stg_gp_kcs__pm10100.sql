with source as (

    select * from {{ source('kcs_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        debitamt,
        xchgrate,
        disttype,
        dex_row_id,
        exchdate,
        mctrxstt,
        userid,
        curncyid,
        dstindx,
        distref,
        crdtamnt,
        ordbtamt,
        iccurrix,
        decplacs,
        interid,
        time1,
        pstgdate,
        aptodcty,
        rtclcmtd,
        ratetpid,
        denxrate,
        expndate,
        currnidx,
        exgtblid,
        changed,
        pstgstus,
        vendorid,
        trxsorce,
        iccurrid,
        correspondingunit,
        orcrdamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
