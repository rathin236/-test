with source as (

    select * from {{ source('nni_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        pstgdate,
        expndate,
        dstindx,
        time1,
        denxrate,
        decplacs,
        rtclcmtd,
        iccurrid,
        correspondingunit,
        disttype,
        vendorid,
        orcrdamt,
        trxsorce,
        currnidx,
        userid,
        xchgrate,
        exgtblid,
        ordbtamt,
        ratetpid,
        exchdate,
        pstgstus,
        dex_row_id,
        interid,
        changed,
        iccurrix,
        crdtamnt,
        distref,
        debitamt,
        curncyid,
        aptodcty,
        mctrxstt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
