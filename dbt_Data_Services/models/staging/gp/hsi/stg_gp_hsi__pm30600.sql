with source as (

    select * from {{ source('hsi_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        curncyid,
        doctype,
        pstgdate,
        distref,
        orcrdamt,
        userid,
        crdtamnt,
        dex_row_id,
        changed,
        trxsorce,
        currnidx,
        vendorid,
        disttype,
        ordbtamt,
        aptodcty,
        pstgstus,
        debitamt,
        dstindx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
