with source as (

    select * from {{ source('caglp_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        debitamt,
        dstindx,
        rtclcmtd,
        denxrate,
        curncyid,
        distref,
        interid,
        mctrxstt,
        aptodcty,
        dex_row_id,
        crdtamnt,
        ordbtamt,
        ratetpid,
        disttype,
        correspondingunit,
        iccurrix,
        trxsorce,
        currnidx,
        userid,
        pstgdate,
        changed,
        exgtblid,
        decplacs,
        pstgstus,
        time1,
        vendorid,
        iccurrid,
        xchgrate,
        orcrdamt,
        exchdate,
        expndate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
