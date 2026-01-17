with source as (

    select * from {{ source('cai_dbo', 'pm30600') }}

),

renamed as (

    select
        aptvchnm,
        cntrltyp,
        dstsqnum,
        spcldist,
        vchrnmbr,
        distref,
        disttype,
        ordbtamt,
        debitamt,
        crdtamnt,
        trxsorce,
        changed,
        currnidx,
        curncyid,
        vendorid,
        dex_row_id,
        aptodcty,
        pstgstus,
        pstgdate,
        orcrdamt,
        doctype,
        dstindx,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
