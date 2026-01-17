with source as (

    select * from {{ source('nni_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        debitamt,
        distref,
        currnidx,
        trxsorce,
        posteddt,
        curncyid,
        ordbtamt,
        dcstatus,
        crdtamnt,
        dstindx,
        dex_row_id,
        orcrdamt,
        categusd,
        posted,
        disttype,
        projctid,
        changed,
        custnmbr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
