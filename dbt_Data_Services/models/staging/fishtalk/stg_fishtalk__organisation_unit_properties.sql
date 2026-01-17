with

source as (

    select * from {{ source('fishtalk', 'organisationunitproperties') }}

),

renamed as (

    select
        stringvalue,
        doublevalue,
        datetimevalue,
        _fivetran_deleted,
        _fivetran_synced,
        trim(orgunitid) as orgunitid,
        trim(upper(propertyid)) as propertyid

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
