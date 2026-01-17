with source as (

    select * from {{ source('nb601_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        vendorid,
        currnidx,
        userid,
        pstgstus,
        changed,
        ordbtamt,
        dstindx,
        disttype,
        curncyid,
        crdtamnt,
        debitamt,
        trxsorce,
        doctype,
        orcrdamt,
        dex_row_id,
        aptodcty,
        distref,
        pstgdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
