with source as (

    select * from {{ source('tns_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dcstatus,
        projctid,
        disttype,
        categusd,
        posteddt,
        dex_row_id,
        crdtamnt,
        trxsorce,
        curncyid,
        changed,
        custnmbr,
        currnidx,
        posted,
        dstindx,
        debitamt,
        orcrdamt,
        ordbtamt,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
