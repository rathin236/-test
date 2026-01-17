with source as (

    select * from {{ source('cafl_dbo', 'rm30301') }}

),

renamed as (

    select
        posteddt,
        categusd,
        rmdtypal,
        orcrdamt,
        debitamt,
        projctid,
        dstindx,
        custnmbr,
        dex_row_id,
        docnumbr,
        ordbtamt,
        currnidx,
        distref,
        disttype,
        userid,
        curncyid,
        trxsorce,
        seqnumbr,
        crdtamnt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
