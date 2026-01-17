with source as (

    select * from {{ source('hsi_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        ordbtamt,
        distref,
        dex_row_id,
        dcstatus,
        curncyid,
        posteddt,
        orcrdamt,
        currnidx,
        trxsorce,
        disttype,
        posted,
        debitamt,
        changed,
        crdtamnt,
        dstindx,
        projctid,
        categusd,
        custnmbr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
