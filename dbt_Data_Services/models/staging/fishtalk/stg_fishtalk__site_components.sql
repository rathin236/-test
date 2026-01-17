with source as (

    select * from {{ source('xref', 'site_components') }}

),

site_components as (

    select
        site,
        siteid as site_id,
        component,
        growth_model,
        mortality_model

    from source

)

select * from site_components
