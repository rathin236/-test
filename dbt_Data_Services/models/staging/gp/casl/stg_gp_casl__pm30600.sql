with source as (

    select * from {{ source('casl_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        pstgdate,
        disttype,
        trxsorce,
        changed,
        doctype,
        vendorid,
        pstgstus,
        orcrdamt,
        curncyid,
        crdtamnt,
        dstindx,
        ordbtamt,
        dex_row_id,
        aptodcty,
        debitamt,
        distref,
        currnidx,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
