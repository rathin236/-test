with source as (

    select * from {{ source('cfami_dbo', 'rm30301') }}

),

renamed as (

    select
        disttype,
        seqnumbr,
        custnmbr,
        posteddt,
        dex_row_id,
        distref,
        dstindx,
        trxsorce,
        userid,
        debitamt,
        curncyid,
        ordbtamt,
        currnidx,
        crdtamnt,
        rmdtypal,
        projctid,
        categusd,
        docnumbr,
        orcrdamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
