with source as (

    select * from {{ source('nns_dbo', 'pm30600') }}

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
        dex_row_id,
        distref,
        changed,
        pstgstus,
        pstgdate,
        userid,
        doctype,
        crdtamnt,
        debitamt,
        aptodcty,
        trxsorce,
        curncyid,
        vendorid,
        ordbtamt,
        dstindx,
        orcrdamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
