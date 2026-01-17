with source as (

    select * from {{ source('sti_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        dex_row_id,
        dstindx,
        custnmbr,
        debitamt,
        orcrdamt,
        distref,
        ordbtamt,
        disttype,
        currnidx,
        trxsorce,
        posteddt,
        projctid,
        userid,
        curncyid,
        crdtamnt,
        categusd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
