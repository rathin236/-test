with source as (

    select * from {{ source('tnsus_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        curncyid,
        dex_row_id,
        doctype,
        crdtamnt,
        trxsorce,
        disttype,
        vendorid,
        pstgdate,
        currnidx,
        orcrdamt,
        changed,
        pstgstus,
        ordbtamt,
        debitamt,
        dstindx,
        userid,
        aptodcty,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
