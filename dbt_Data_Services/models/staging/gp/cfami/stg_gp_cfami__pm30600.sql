with source as (

    select * from {{ source('cfami_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        curncyid,
        changed,
        trxsorce,
        dstindx,
        doctype,
        distref,
        vendorid,
        ordbtamt,
        aptodcty,
        dex_row_id,
        userid,
        pstgstus,
        currnidx,
        crdtamnt,
        debitamt,
        disttype,
        orcrdamt,
        pstgdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
