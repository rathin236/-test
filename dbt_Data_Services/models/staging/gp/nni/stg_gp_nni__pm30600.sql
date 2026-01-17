with source as (

    select * from {{ source('nni_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        debitamt,
        changed,
        pstgstus,
        ordbtamt,
        crdtamnt,
        curncyid,
        orcrdamt,
        trxsorce,
        aptodcty,
        vendorid,
        currnidx,
        dstindx,
        dex_row_id,
        userid,
        pstgdate,
        doctype,
        distref,
        disttype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
