with source as (

    select * from {{ source('cos_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dcstatus,
        crdtamnt,
        changed,
        projctid,
        posted,
        disttype,
        currnidx,
        posteddt,
        curncyid,
        trxsorce,
        distref,
        debitamt,
        orcrdamt,
        dex_row_id,
        custnmbr,
        categusd,
        dstindx,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
