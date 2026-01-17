with source as (

    select * from {{ source('cap_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        custnmbr,
        crdtamnt,
        categusd,
        ordbtamt,
        distref,
        curncyid,
        orcrdamt,
        dex_row_id,
        trxsorce,
        dcstatus,
        changed,
        dstindx,
        debitamt,
        posteddt,
        projctid,
        posted,
        currnidx,
        disttype,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
