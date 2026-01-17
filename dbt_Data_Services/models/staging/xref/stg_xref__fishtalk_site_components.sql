with

source as (

    select * from {{ source('xref', 'site_components') }}

),

renamed as (

    select
        site,
        component,
        growth_model,
        mortality_model,
        trim(siteid) as siteid

    from source

)

select * from renamed
