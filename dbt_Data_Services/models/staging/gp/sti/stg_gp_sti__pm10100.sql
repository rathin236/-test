with source as (

    select * from {{ source('sti_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        rtclcmtd,
        vendorid,
        aptodcty,
        distref,
        trxsorce,
        debitamt,
        userid,
        denxrate,
        iccurrix,
        dex_row_id,
        exchdate,
        orcrdamt,
        dstindx,
        expndate,
        disttype,
        xchgrate,
        decplacs,
        iccurrid,
        pstgdate,
        interid,
        mctrxstt,
        curncyid,
        time1,
        correspondingunit,
        currnidx,
        ordbtamt,
        ratetpid,
        exgtblid,
        changed,
        pstgstus,
        crdtamnt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
