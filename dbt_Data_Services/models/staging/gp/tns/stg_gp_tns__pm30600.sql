with source as (

    select * from {{ source('tns_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        disttype,
        crdtamnt,
        vendorid,
        debitamt,
        dex_row_id,
        pstgstus,
        doctype,
        curncyid,
        userid,
        trxsorce,
        aptodcty,
        distref,
        ordbtamt,
        dstindx,
        pstgdate,
        changed,
        currnidx,
        orcrdamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
