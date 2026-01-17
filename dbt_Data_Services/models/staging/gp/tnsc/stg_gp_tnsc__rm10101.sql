with source as (

    select * from {{ source('tnsc_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        debitamt,
        crdtamnt,
        changed,
        currnidx,
        trxsorce,
        posteddt,
        disttype,
        orcrdamt,
        dcstatus,
        curncyid,
        ordbtamt,
        distref,
        projctid,
        categusd,
        posted,
        custnmbr,
        dex_row_id,
        dstindx,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
