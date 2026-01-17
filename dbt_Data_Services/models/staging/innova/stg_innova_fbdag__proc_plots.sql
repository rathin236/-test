with source as (

    select * from {{ source('innova_fbdag', 'proc_plots') }}

),

renamed as (

    select
        plot,
        itgrsite,
        objecttemplate,
        createdby,
        active,
        modifiedby,
        description2,
        validfrom,
        name,
        description6,
        "ORDER",
        created,
        dimension3,
        description3,
        modified,
        description1,
        description4,
        dimension4,
        validto,
        dimension1,
        itgrstatus,
        description7,
        dimension2,
        shname,
        pattern,
        description5,
        description8,
        xmldata,
        bom,
        reftime,
        extcode,
        plotstatus,
        _fivetran_deleted,
        _fivetran_synced,
        trim(code) as code

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
