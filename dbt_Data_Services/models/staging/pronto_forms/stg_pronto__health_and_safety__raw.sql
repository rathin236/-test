with

source as (

    select * from {{ source('health_and_safety', 'pronto_forms_raw') }}

),

renamed as (

    select
        json_data,
        form_name,
        created_date,
        executionid

    from source
    where form_name in ('Monthly Safety Inspection Checklist - SW Operations',
                        'Monthly Safety Inspection Checklist - Freshwater Hatcheries',
                        'Field Level Hazard Assessment')

)

select * from renamed
