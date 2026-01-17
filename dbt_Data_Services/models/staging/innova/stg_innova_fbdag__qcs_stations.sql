with

source as (

    select * from {{ source('innova_fbdag', 'qcs_stations') }}

),

renamed as (

    select
        id,
        device,
        prunit,
        defaultmaterial,
        name,
        sourceprunit,
        active,
        system,
        xmldata,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
