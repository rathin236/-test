with source as (

    select * from {{ source('northscope', 'erpx_mfattribute') }}

),

renamed as (

    select
        dataentitycompanysk,
        attribute,
        attributetypesk,
        createddatetime,
        sort,
        createdby,
        escapedname,
        attributesk,
        lastuser,
        lastupdated,
        attributedatatypeen,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
