with source as (

    select * from {{ source('stusa_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        projctid,
        crdtamnt,
        disttype,
        dstindx,
        custnmbr,
        orcrdamt,
        dex_row_id,
        ordbtamt,
        posteddt,
        trxsorce,
        changed,
        currnidx,
        distref,
        posted,
        debitamt,
        dcstatus,
        categusd,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
