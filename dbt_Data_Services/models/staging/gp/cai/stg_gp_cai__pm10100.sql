with source as (

    select * from {{ source('cai_dbo', 'pm10100') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        xchgrate,
        curncyid,
        dstindx,
        ordbtamt,
        rtclcmtd,
        expndate,
        correspondingunit,
        pstgdate,
        orcrdamt,
        vendorid,
        iccurrid,
        trxsorce,
        pstgstus,
        exgtblid,
        distref,
        disttype,
        currnidx,
        iccurrix,
        crdtamnt,
        dex_row_id,
        exchdate,
        decplacs,
        changed,
        time1,
        interid,
        ratetpid,
        userid,
        aptodcty,
        denxrate,
        debitamt,
        mctrxstt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
