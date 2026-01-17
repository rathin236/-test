with source as (

    select * from {{ source('hpi_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        crdtamnt,
        currnidx,
        ordbtamt,
        vendorid,
        disttype,
        changed,
        dstindx,
        curncyid,
        pstgdate,
        aptodcty,
        doctype,
        distref,
        orcrdamt,
        trxsorce,
        pstgstus,
        userid,
        debitamt,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
