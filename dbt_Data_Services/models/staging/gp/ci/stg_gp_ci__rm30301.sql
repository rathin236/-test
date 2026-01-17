with source as (

    select * from {{ source('ci_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        seqnumbr,
        projctid,
        dex_row_id,
        dstindx,
        debitamt,
        currnidx,
        ordbtamt,
        categusd,
        custnmbr,
        crdtamnt,
        rmdtypal,
        distref,
        trxsorce,
        userid,
        disttype,
        orcrdamt,
        curncyid,
        posteddt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
