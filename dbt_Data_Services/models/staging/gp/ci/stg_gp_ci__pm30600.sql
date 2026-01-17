with source as (

    select * from {{ source('ci_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        debitamt,
        orcrdamt,
        userid,
        disttype,
        dstindx,
        pstgdate,
        curncyid,
        ordbtamt,
        doctype,
        dex_row_id,
        distref,
        trxsorce,
        vendorid,
        aptodcty,
        changed,
        pstgstus,
        crdtamnt,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
