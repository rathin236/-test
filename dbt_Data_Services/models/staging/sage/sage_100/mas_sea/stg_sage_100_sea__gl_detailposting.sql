with

source as (

    select * from {{ source('mas_sea_dbo', 'gl_detailposting') }}

),

renamed as (

    select
        accountkey,
        journalregisterno,
        postingdate,
        sequenceno,
        sourcejournal,
        timecreated,
        poissuecomment,
        creditamount,
        documentno,
        docsequenceno,
        linedate,
        postingcomment,
        linebankcode,
        datecreated,
        usercreatedkey,
        batchtype,
        debitamount,
        linedocrefer,
        documenttype,
        headerrec,
        sourcemodule,
        receiptno,
        batchno,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select *
from renamed
where coalesce(_fivetran_deleted, false) = false
