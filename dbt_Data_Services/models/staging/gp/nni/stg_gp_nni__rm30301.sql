with source as (

    select * from {{ source('nni_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        currnidx,
        distref,
        curncyid,
        userid,
        ordbtamt,
        crdtamnt,
        trxsorce,
        posteddt,
        dstindx,
        dex_row_id,
        orcrdamt,
        categusd,
        disttype,
        projctid,
        debitamt,
        custnmbr,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
