with source as (

    select * from {{ source('ci_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        orcrdamt,
        debitamt,
        changed,
        projctid,
        disttype,
        crdtamnt,
        posteddt,
        dcstatus,
        categusd,
        dex_row_id,
        custnmbr,
        distref,
        curncyid,
        ordbtamt,
        dstindx,
        posted,
        trxsorce,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
