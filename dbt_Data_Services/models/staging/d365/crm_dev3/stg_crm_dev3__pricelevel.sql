with

source as (

    select * from {{ source('crm_dev3', 'pricelevel') }}

),

renamed as (

    select
        pricelevelid,
        freighttermscode,
        description,
        shippingmethodcode,
        utcconversiontimezonecode,
        _cai_productid_value,
        versionnumber,
        statecode,
        _organizationid_value,
        modifiedon,
        _createdonbehalfby_value,
        name,
        importsequencenumber,
        _modifiedonbehalfby_value,
        statuscode,
        createdon,
        paymentmethodcode,
        exchangerate,
        enddate,
        begindate,
        _modifiedby_value,
        _transactioncurrencyid_value,
        overriddencreatedon,
        _createdby_value,
        timezoneruleversionnumber,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
