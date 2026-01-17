with

source as (

    select * from {{ source('crm_dev3', 'stringmap') }}

),

renamed as (

    select
        stringmapid,
        attributename,
        objecttypecode,
        organizationid,
        versionnumber,
        langid,
        attributevalue::string as attributevalue,
        displayorder,
        _fivetran_deleted,
        _fivetran_synced,
        upper(trim(value::string)) as activevalue

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
