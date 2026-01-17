with source as (

    select * from {{ source('northscope', 'erpx_mfdataentitycompany') }}

),

renamed as (

    select
        companyname,
        datalayerid,
        companyid,
        companylogofilelocation,
        companyshortname,
        dataentitycompanysk,
        dataentitycompanysystemsk,
        physicaladdresssk,
        mailingaddresssk,
        databasename,
        servername,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
