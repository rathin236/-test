with

source as (

    select * from {{ source('crm_dev3', 'uomschedule') }}

),

renamed as (

    select
        uomscheduleid,
        statecode,
        baseuomname,
        _modifiedonbehalfby_value,
        importsequencenumber,
        statuscode,
        _organizationid_value,
        _createdonbehalfby_value,
        timezoneruleversionnumber,
        _modifiedbyexternalparty_value,
        versionnumber,
        _createdby_value,
        name,
        description,
        createdon,
        utcconversiontimezonecode,
        _modifiedby_value,
        overriddencreatedon,
        _createdbyexternalparty_value,
        modifiedon,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
