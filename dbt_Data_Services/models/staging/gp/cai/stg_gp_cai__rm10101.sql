with source as (

    select * from {{ source('cai_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        dcstatus,
        distref,
        disttype,
        debitamt,
        categusd,
        trxsorce,
        posted,
        crdtamnt,
        curncyid,
        changed,
        dex_row_id,
        dstindx,
        orcrdamt,
        projctid,
        currnidx,
        posteddt,
        custnmbr,
        ordbtamt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
