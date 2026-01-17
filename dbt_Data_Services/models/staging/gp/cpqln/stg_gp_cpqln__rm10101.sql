with source as (

    select * from {{ source('cpqln_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        posteddt,
        currnidx,
        ordbtamt,
        dex_row_id,
        orcrdamt,
        dstindx,
        trxsorce,
        curncyid,
        posted,
        changed,
        distref,
        crdtamnt,
        categusd,
        dcstatus,
        custnmbr,
        disttype,
        debitamt,
        projctid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
