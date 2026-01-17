with source as (

    select * from {{ source('northscope', 'erpx_gljournalheader') }}

),

renamed as (

    select
        dataentitycompanysk,
        masternumberoverride,
        createdby,
        journaltransactiontypesk,
        sourcetransactiondetail,
        sourcetransactiontypename,
        sourcetransactiontypesk,
        sourcemodulesk,
        postedby,
        transactionstatussk,
        journalid,
        exchangesk,
        reference,
        lastupdated,
        hostjournalid,
        sourcetransactionsk,
        lastuser,
        reversingdate,
        sourcetransactioncurrencysk,
        exchangerate,
        posteddate,
        sourcetransactionid,
        manuallyupdated,
        exchangeratecalculationmethoden,
        comment,
        journalheadersk,
        masternumber,
        journaldate,
        createddate,
        journaltransactionclasssk,
        currencysk,
        sourcetransactiondate,
        integratetohost,
        zerosumjournal,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
