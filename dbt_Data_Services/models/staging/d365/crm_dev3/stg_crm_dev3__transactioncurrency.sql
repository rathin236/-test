with

source as (

    select * from {{ source('crm_dev3', 'transactioncurrency') }}

),

renamed as (

    select
        transactioncurrencyid,
        _createdonbehalfby_value,
        isocurrencycode,
        _createdby_value,
        statuscode,
        _organizationid_value,
        currencyname,
        overriddencreatedon,
        entityimage,
        entityimageid,
        exchangerate,
        currencysymbol,
        entityimage_url,
        importsequencenumber,
        createdon,
        currencyprecision,
        _modifiedonbehalfby_value,
        modifiedon,
        entityimage_timestamp,
        statecode,
        versionnumber,
        _modifiedby_value,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
