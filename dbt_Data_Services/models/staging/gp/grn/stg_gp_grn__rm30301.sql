with source as (

    select * from {{ source('grn_dbo', 'rm30301') }}

),

renamed as (

    select
        docnumbr,
        rmdtypal,
        seqnumbr,
        disttype,
        projctid,
        userid,
        posteddt,
        trxsorce,
        categusd,
        dex_row_id,
        curncyid,
        custnmbr,
        crdtamnt,
        currnidx,
        orcrdamt,
        debitamt,
        dstindx,
        distref,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
