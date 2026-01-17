with source as (

    select * from {{ source('slgp_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dcstatus,
        disttype,
        debitamt,
        dstindx,
        crdtamnt,
        custnmbr,
        dex_row_id,
        ordbtamt,
        projctid,
        currnidx,
        posteddt,
        orcrdamt,
        posted,
        changed,
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
