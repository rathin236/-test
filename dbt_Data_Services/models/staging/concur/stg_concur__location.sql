with

source as (

    select * from {{ source('concur', 'location') }}

),

renamed as (

    select
        id,
        administrative_region,
        country,
        country_subdivision,
        iatacode,
        is_airport,
        is_booking_tool,
        latitude,
        longitude,
        name,
        _fivetran_synced

    from source

)

select * from renamed
