with source as (

    select * from {{ source('casl_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dcstatus,
        changed,
        custnmbr,
        categusd,
        trxsorce,
        projctid,
        curncyid,
        ordbtamt,
        posted,
        orcrdamt,
        dstindx,
        currnidx,
        dex_row_id,
        debitamt,
        crdtamnt,
        distref,
        posteddt,
        disttype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
