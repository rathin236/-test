with source as (

    select * from {{ source('tnsus_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        posted,
        dex_row_id,
        dstindx,
        distref,
        crdtamnt,
        curncyid,
        currnidx,
        trxsorce,
        changed,
        orcrdamt,
        posteddt,
        ordbtamt,
        disttype,
        projctid,
        categusd,
        debitamt,
        dcstatus,
        custnmbr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
