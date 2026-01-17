with source as (

    select * from {{ source('cafl_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        changed,
        curncyid,
        ordbtamt,
        custnmbr,
        currnidx,
        disttype,
        dex_row_id,
        dcstatus,
        posted,
        orcrdamt,
        projctid,
        debitamt,
        crdtamnt,
        categusd,
        dstindx,
        distref,
        posteddt,
        trxsorce,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
