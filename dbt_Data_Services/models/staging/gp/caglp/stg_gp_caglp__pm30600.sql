with source as (

    select * from {{ source('caglp_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        disttype,
        currnidx,
        pstgdate,
        dstindx,
        aptodcty,
        distref,
        trxsorce,
        orcrdamt,
        debitamt,
        changed,
        userid,
        ordbtamt,
        crdtamnt,
        pstgstus,
        doctype,
        curncyid,
        dex_row_id,
        vendorid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
