with source as (

    select * from {{ source('culc4_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        userid,
        disttype,
        distref,
        dex_row_id,
        changed,
        doctype,
        crdtamnt,
        pstgstus,
        debitamt,
        orcrdamt,
        dstindx,
        curncyid,
        aptodcty,
        vendorid,
        currnidx,
        ordbtamt,
        trxsorce,
        pstgdate,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
