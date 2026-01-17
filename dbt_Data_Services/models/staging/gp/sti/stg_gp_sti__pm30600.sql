with source as (

    select * from {{ source('sti_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        changed,
        dex_row_id,
        doctype,
        dstindx,
        trxsorce,
        disttype,
        distref,
        pstgdate,
        userid,
        ordbtamt,
        orcrdamt,
        pstgstus,
        crdtamnt,
        currnidx,
        debitamt,
        vendorid,
        aptodcty,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
