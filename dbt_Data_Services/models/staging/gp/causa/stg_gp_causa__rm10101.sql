with source as (

    select * from {{ source('causa_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        trxsorce,
        curncyid,
        custnmbr,
        ordbtamt,
        changed,
        dcstatus,
        posted,
        orcrdamt,
        disttype,
        dstindx,
        currnidx,
        crdtamnt,
        dex_row_id,
        projctid,
        debitamt,
        distref,
        posteddt,
        categusd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
