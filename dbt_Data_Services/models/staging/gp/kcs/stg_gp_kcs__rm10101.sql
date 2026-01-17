with source as (

    select * from {{ source('kcs_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        debitamt,
        posteddt,
        crdtamnt,
        currnidx,
        projctid,
        ordbtamt,
        orcrdamt,
        distref,
        posted,
        dstindx,
        dex_row_id,
        trxsorce,
        changed,
        curncyid,
        disttype,
        custnmbr,
        dcstatus,
        categusd,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
