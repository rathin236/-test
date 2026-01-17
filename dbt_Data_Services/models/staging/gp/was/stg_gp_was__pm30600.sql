with source as (

    select * from {{ source('was_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        vendorid,
        pstgstus,
        pstgdate,
        currnidx,
        trxsorce,
        debitamt,
        curncyid,
        ordbtamt,
        userid,
        dex_row_id,
        crdtamnt,
        dstindx,
        disttype,
        doctype,
        aptodcty,
        orcrdamt,
        changed,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
