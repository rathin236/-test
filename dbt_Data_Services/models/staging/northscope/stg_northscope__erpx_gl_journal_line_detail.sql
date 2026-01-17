with source as (

    select * from {{ source('northscope', 'erpx_gljournallinedetail') }}

),

renamed as (

    select
        sourcetransactionid,
        dataentitycompanysk,
        mfdistributionaccounttypeen,
        journallinetypesk,
        creditamount,
        glaccountsk,
        debitamount,
        transcurrencycreditamount,
        lastupdated,
        sourcetransactionlinesk,
        accountsourcedescriptionen,
        journalheadersk,
        description,
        lastuser,
        distributionaccountsk,
        sourcetransactionsk,
        journallinedetailsk,
        transcurrencydebitamount,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
