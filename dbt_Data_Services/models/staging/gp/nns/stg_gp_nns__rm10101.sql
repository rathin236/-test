with source as (

    select * from {{ source('nns_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        orcrdamt,
        dstindx,
        projctid,
        dex_row_id,
        posted,
        crdtamnt,
        distref,
        changed,
        categusd,
        custnmbr,
        debitamt,
        curncyid,
        posteddt,
        trxsorce,
        currnidx,
        dcstatus,
        ordbtamt,
        disttype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
