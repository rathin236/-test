with source as (

    select * from {{ source('nb601_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        currnidx,
        projctid,
        ordbtamt,
        dstindx,
        posted,
        dcstatus,
        disttype,
        curncyid,
        dex_row_id,
        orcrdamt,
        categusd,
        distref,
        custnmbr,
        changed,
        debitamt,
        trxsorce,
        posteddt,
        crdtamnt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
