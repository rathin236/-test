with source as (

    select * from {{ source('slgp_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        debitamt,
        disttype,
        userid,
        custnmbr,
        dex_row_id,
        posteddt,
        crdtamnt,
        ordbtamt,
        dstindx,
        currnidx,
        projctid,
        orcrdamt,
        trxsorce,
        curncyid,
        categusd,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
