with source as (

    select * from {{ source('tfci_dbo', 'rm10101') }}

),

renamed as (

    select
        docnumbr,
        pstgstus,
        rmdtypal,
        seqnumbr,
        userid,
        projctid,
        crdtamnt,
        trxsorce,
        disttype,
        dex_row_id,
        curncyid,
        currnidx,
        dstindx,
        categusd,
        dcstatus,
        debitamt,
        distref,
        custnmbr,
        changed,
        orcrdamt,
        posted,
        ordbtamt,
        posteddt,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
