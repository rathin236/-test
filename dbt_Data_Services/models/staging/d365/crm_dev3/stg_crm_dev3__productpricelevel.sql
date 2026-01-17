with

source as (

    select * from {{ source('crm_dev3', 'productpricelevel') }}

),

renamed as (

    select
        productpricelevelid,
        _productid_value,
        _transactioncurrencyid_value,
        _createdonbehalfby_value,
        versionnumber,
        timezoneruleversionnumber,
        exchangerate,
        processid,
        _discounttypeid_value,
        createdon,
        percentage,
        roundingoptionamount_base,
        amount_base,
        importsequencenumber,
        _pricelevelid_value,
        _uomscheduleid_value,
        _createdby_value,
        roundingoptioncode,
        roundingoptionamount,
        modifiedon,
        organizationid,
        quantitysellingcode,
        stageid,
        amount,
        traversedpath,
        pricingmethodcode,
        _modifiedby_value,
        _uomid_value,
        utcconversiontimezonecode,
        _modifiedonbehalfby_value,
        overriddencreatedon,
        roundingpolicycode,
        _fivetran_deleted,
        _fivetran_synced,
        trim(productnumber::string) as prodnumber

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
