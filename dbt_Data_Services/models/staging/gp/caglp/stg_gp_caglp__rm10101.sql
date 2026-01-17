with source as (

    select * from {{ source('caglp_dbo', 'rm10101') }}

),

renamed as (

    select
        changed,
        dcstatus,
        categusd,
        posted,
        disttype,
        posteddt,
        crdtamnt,
        projctid,
        seqnumbr,
        orcrdamt,
        pstgstus,
        custnmbr,
        ordbtamt,
        dstindx,
        currnidx,
        trxsorce,
        rmdtypal,
        dex_row_id,
        debitamt,
        distref,
        userid,
        docnumbr,
        curncyid,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
