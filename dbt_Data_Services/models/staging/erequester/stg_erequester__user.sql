with

source as (

    select * from {{ source('erequester_dbo', 'user') }}

),

renamed as (

    select
        userid,
        datecreated,
        pwdchangedate,
        cardholderid,
        lastupdated,
        lastupdateddate,
        pwdreset,
        jobtitle,
        allowcrosssearch,
        remembersearchresults,
        defaultitementrytomassedit,
        lastlogon,
        outofoffice,
        defaulttabonmobiledevices,
        admin,
        preferredlanguage,
        password,
        pwdfailedattempts,
        lastname,
        disabled,
        templatestabdefaultsortfieldnumber,
        firstname,
        concurrentdisabled,
        approvalnotificationpref,
        fax,
        allowcrosscompanyapproval,
        requisitionlistdefaultpagesize,
        phone,
        email,
        lastupdatedby,
        username,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
