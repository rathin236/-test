with source as (

    select * from {{ source('cap_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        changed,
        doctype,
        aptodcty,
        userid,
        pstgdate,
        pstgstus,
        vendorid,
        dex_row_id,
        trxsorce,
        crdtamnt,
        currnidx,
        ordbtamt,
        dstindx,
        curncyid,
        orcrdamt,
        disttype,
        distref,
        debitamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
