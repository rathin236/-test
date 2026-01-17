with source as (

    select * from {{ source('stusa_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        doctype,
        dex_row_id,
        disttype,
        crdtamnt,
        distref,
        userid,
        orcrdamt,
        trxsorce,
        currnidx,
        pstgstus,
        ordbtamt,
        dstindx,
        curncyid,
        aptodcty,
        debitamt,
        pstgdate,
        changed,
        vendorid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
