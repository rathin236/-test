with source as (

    select * from {{ source('kcs_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        vendorid,
        doctype,
        changed,
        crdtamnt,
        ordbtamt,
        disttype,
        curncyid,
        dex_row_id,
        dstindx,
        distref,
        currnidx,
        pstgstus,
        trxsorce,
        orcrdamt,
        pstgdate,
        debitamt,
        aptodcty,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
