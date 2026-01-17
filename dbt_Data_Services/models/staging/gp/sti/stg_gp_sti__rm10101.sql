with source as (

    select * from {{ source('sti_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dstindx,
        dex_row_id,
        custnmbr,
        curncyid,
        orcrdamt,
        trxsorce,
        changed,
        dcstatus,
        distref,
        debitamt,
        ordbtamt,
        currnidx,
        disttype,
        posteddt,
        projctid,
        posted,
        categusd,
        crdtamnt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
