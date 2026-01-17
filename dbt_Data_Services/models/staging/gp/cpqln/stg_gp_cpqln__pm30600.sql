with source as (

    select * from {{ source('cpqln_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        pstgdate,
        curncyid,
        aptodcty,
        dex_row_id,
        pstgstus,
        distref,
        doctype,
        crdtamnt,
        userid,
        changed,
        trxsorce,
        disttype,
        vendorid,
        dstindx,
        currnidx,
        debitamt,
        orcrdamt,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
