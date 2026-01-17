with source as (

    select * from {{ source('tnm_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        doctype,
        crdtamnt,
        pstgdate,
        changed,
        vendorid,
        aptodcty,
        ordbtamt,
        dstindx,
        debitamt,
        curncyid,
        currnidx,
        distref,
        disttype,
        trxsorce,
        orcrdamt,
        dex_row_id,
        pstgstus,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
