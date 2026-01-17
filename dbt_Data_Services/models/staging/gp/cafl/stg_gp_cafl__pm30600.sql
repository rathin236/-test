with source as (

    select * from {{ source('cafl_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        orcrdamt,
        userid,
        aptodcty,
        crdtamnt,
        distref,
        dex_row_id,
        currnidx,
        changed,
        ordbtamt,
        pstgdate,
        curncyid,
        debitamt,
        dstindx,
        disttype,
        vendorid,
        doctype,
        pstgstus,
        trxsorce,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
