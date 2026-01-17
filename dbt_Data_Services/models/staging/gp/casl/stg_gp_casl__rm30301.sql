with source as (

    select * from {{ source('casl_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        posteddt,
        categusd,
        userid,
        projctid,
        curncyid,
        orcrdamt,
        ordbtamt,
        dstindx,
        trxsorce,
        dex_row_id,
        debitamt,
        crdtamnt,
        distref,
        custnmbr,
        disttype,
        currnidx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
