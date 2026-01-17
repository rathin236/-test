with source as (

    select * from {{ source('gmg_dbo', 'rm30301') }}

),

renamed as (

    select
        categusd,
        docnumbr,
        debitamt,
        trxsorce,
        curncyid,
        posteddt,
        seqnumbr,
        disttype,
        distref,
        currnidx,
        crdtamnt,
        custnmbr,
        projctid,
        rmdtypal,
        ordbtamt,
        userid,
        dex_row_id,
        dstindx,
        orcrdamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
