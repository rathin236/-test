with

source as (

    select * from {{ source('crm_dev3', 'uom') }}

),

renamed as (

    select
        uomid,
        isschedulebaseuom,
        organizationid,
        _createdonbehalfby_value,
        _createdby_value,
        quantity,
        utcconversiontimezonecode,
        versionnumber,
        modifiedon,
        _uomscheduleid_value,
        _modifiedby_value,
        importsequencenumber,
        overriddencreatedon,
        timezoneruleversionnumber,
        _createdbyexternalparty_value,
        _baseuom_value,
        _modifiedonbehalfby_value,
        _modifiedbyexternalparty_value,
        createdon,
        _fivetran_deleted,
        _fivetran_synced,
        name as unitname

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
