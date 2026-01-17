with source as (

    select * from {{ source('cafl_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        vendorid,
        orcrdamt,
        currnidx,
        distref,
        expndate,
        dstindx,
        iccurrix,
        userid,
        exgtblid,
        denxrate,
        rtclcmtd,
        decplacs,
        crdtamnt,
        debitamt,
        trxsorce,
        correspondingunit,
        ordbtamt,
        time1,
        disttype,
        iccurrid,
        exchdate,
        curncyid,
        dex_row_id,
        mctrxstt,
        changed,
        pstgstus,
        xchgrate,
        interid,
        aptodcty,
        pstgdate,
        ratetpid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
