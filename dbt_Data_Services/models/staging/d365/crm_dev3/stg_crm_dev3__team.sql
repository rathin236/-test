with

source as (

    select * from {{ source('crm_dev3', 'team') }}

),

renamed as (

    select
        ownerid,
        _transactioncurrencyid_value,
        versionnumber,
        yominame,
        _teamtemplateid_value,
        _modifiedonbehalfby_value,
        isdefault,
        traversedpath,
        organizationid,
        modifiedon,
        name,
        _regardingobjectid_value,
        exchangerate,
        importsequencenumber,
        systemmanaged,
        description,
        _createdby_value,
        emailaddress,
        processid,
        _businessunitid_value,
        _createdonbehalfby_value,
        _queueid_value,
        _modifiedby_value,
        overriddencreatedon,
        teamtype,
        sharelinkqualifier,
        stageid,
        membershiptype,
        createdon,
        issastokenset,
        azureactivedirectoryobjectid,
        _administratorid_value,
        teamid,
        _fivetran_deleted,
        _fivetran_synced,
        _delegatedauthorizationid_value

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
