with

source as (

    select * from {{ source('innova_fbdag', 'proc_shifts') }}

),

renamed as (

    select
        shift,
        objecttemplate,
        createdby,
        active,
        description2,
        modifiedby,
        pattern,
        description8,
        xmldata,
        dimension2,
        description5,
        extcode,
        description4,
        description1,
        itgrstatus,
        dimension1,
        dimension4,
        description7,
        shname,
        code,
        name,
        modified,
        dimension3,
        description6,
        description3,
        created,
        itgrsite,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
