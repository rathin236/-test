with source as (

    select * from {{ source('gcags_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        disttype,
        trxsorce,
        currnidx,
        distref,
        curncyid,
        crdtamnt,
        dex_row_id,
        aptodcty,
        doctype,
        vendorid,
        pstgstus,
        changed,
        dstindx,
        orcrdamt,
        pstgdate,
        ordbtamt,
        debitamt,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
