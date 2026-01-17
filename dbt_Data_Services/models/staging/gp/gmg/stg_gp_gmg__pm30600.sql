with source as (

    select * from {{ source('gmg_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        crdtamnt,
        debitamt,
        aptodcty,
        dex_row_id,
        dstindx,
        curncyid,
        vendorid,
        orcrdamt,
        currnidx,
        ordbtamt,
        pstgdate,
        disttype,
        trxsorce,
        userid,
        changed,
        distref,
        pstgstus,
        doctype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
