with source as (

    select * from {{ source('cos_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        dstindx,
        pstgdate,
        doctype,
        disttype,
        curncyid,
        dex_row_id,
        vendorid,
        changed,
        trxsorce,
        userid,
        pstgstus,
        orcrdamt,
        debitamt,
        currnidx,
        ordbtamt,
        crdtamnt,
        aptodcty,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
