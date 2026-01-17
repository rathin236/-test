with source as (

    select * from {{ source('tnm_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        posteddt,
        debitamt,
        custnmbr,
        crdtamnt,
        curncyid,
        currnidx,
        projctid,
        dex_row_id,
        dcstatus,
        disttype,
        dstindx,
        orcrdamt,
        posted,
        changed,
        trxsorce,
        ordbtamt,
        categusd,
        distref,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
