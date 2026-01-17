with source as (

    select * from {{ source('nb678_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        curncyid,
        pstgdate,
        disttype,
        distref,
        trxsorce,
        userid,
        currnidx,
        ordbtamt,
        crdtamnt,
        dstindx,
        dex_row_id,
        aptodcty,
        orcrdamt,
        vendorid,
        doctype,
        changed,
        pstgstus,
        debitamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
