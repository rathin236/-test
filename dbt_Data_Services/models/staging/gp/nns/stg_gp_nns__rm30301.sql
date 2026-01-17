with source as (

    select * from {{ source('nns_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        trxsorce,
        orcrdamt,
        dstindx,
        posteddt,
        projctid,
        dex_row_id,
        categusd,
        distref,
        crdtamnt,
        debitamt,
        custnmbr,
        curncyid,
        ordbtamt,
        disttype,
        userid,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
