with source as (

    select * from {{ source('tnsc_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        currnidx,
        disttype,
        ordbtamt,
        crdtamnt,
        trxsorce,
        vendorid,
        doctype,
        changed,
        curncyid,
        dex_row_id,
        orcrdamt,
        aptodcty,
        pstgdate,
        debitamt,
        dstindx,
        userid,
        pstgstus,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
