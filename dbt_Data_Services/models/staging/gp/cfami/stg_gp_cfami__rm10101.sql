with source as (

    select * from {{ source('cfami_dbo', 'rm10101') }}

),

renamed as (

    select
        custnmbr,
        debitamt,
        crdtamnt,
        pstgstus,
        dcstatus,
        posted,
        distref,
        categusd,
        dex_row_id,
        docnumbr,
        seqnumbr,
        trxsorce,
        dstindx,
        rmdtypal,
        ordbtamt,
        changed,
        currnidx,
        projctid,
        posteddt,
        orcrdamt,
        disttype,
        curncyid,
        userid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
