with

source as (

    select * from {{ source('innova_fbdag', 'qcs_defectclasses') }}

),

renamed as (

    select
        extcode,
        modifiedby,
        description5,
        dimension2,
        description2,
        createdby,
        description8,
        itgrsite,
        xmldata,
        active,
        description4,
        description1,
        dimension1,
        shname,
        dimension4,
        description7,
        itgrstatus,
        modified,
        created,
        name,
        description3,
        dimension3,
        description6,
        id,
        code,
        objecttemplate,
        pattern,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
