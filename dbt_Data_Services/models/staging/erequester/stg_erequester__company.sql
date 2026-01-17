with source as (

    select * from {{ source('erequester_dbo', 'company') }}

),

renamed as (

    select
        companyid,
        dunsnumber,
        fedid,
        state,
        address1,
        fax,
        city,
        packagetypeid,
        country,
        companycode,
        address2,
        lastupdateddate,
        packagesubtypeid,
        companyname,
        phone2,
        contactphone,
        active,
        zipcode,
        lastupdatedby,
        contactname,
        address3,
        accountingsystemdsn,
        accountingdsn,
        trustedconnection,
        phone1,
        contactemail,
        resalenum,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
