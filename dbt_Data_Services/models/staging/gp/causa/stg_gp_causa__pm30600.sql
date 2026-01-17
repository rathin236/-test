with source as (

    select * from {{ source('causa_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        orcrdamt,
        trxsorce,
        disttype,
        doctype,
        userid,
        pstgdate,
        crdtamnt,
        distref,
        changed,
        dstindx,
        pstgstus,
        dex_row_id,
        currnidx,
        curncyid,
        vendorid,
        ordbtamt,
        aptodcty,
        debitamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
