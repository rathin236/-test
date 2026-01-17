with source as (

    select * from {{ source('nb601_dbo', 'rm30301') }}

),

renamed as (

    select
        rmdtypal,
        dex_row_id,
        curncyid,
        posteddt,
        userid,
        orcrdamt,
        categusd,
        disttype,
        projctid,
        docnumbr,
        debitamt,
        ordbtamt,
        custnmbr,
        crdtamnt,
        distref,
        seqnumbr,
        currnidx,
        dstindx,
        trxsorce,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
