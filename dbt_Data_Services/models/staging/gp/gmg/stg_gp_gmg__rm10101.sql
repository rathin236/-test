with source as (

    select * from {{ source('gmg_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dstindx,
        debitamt,
        dex_row_id,
        projctid,
        currnidx,
        ordbtamt,
        distref,
        trxsorce,
        curncyid,
        dcstatus,
        custnmbr,
        disttype,
        changed,
        posteddt,
        orcrdamt,
        categusd,
        crdtamnt,
        posted,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
