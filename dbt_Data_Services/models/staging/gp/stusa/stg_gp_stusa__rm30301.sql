with source as (

    select * from {{ source('stusa_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        crdtamnt,
        projctid,
        userid,
        categusd,
        posteddt,
        disttype,
        dex_row_id,
        dstindx,
        custnmbr,
        orcrdamt,
        ordbtamt,
        currnidx,
        distref,
        debitamt,
        trxsorce,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
