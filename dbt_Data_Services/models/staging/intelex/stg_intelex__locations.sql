with

source as (

    select * from {{ source('api_report', 'locations') }}

),

renamed as (

    select
        rownum,
        location_name,
        location_id,
        location_code,
        description,
        city,
        state_province,
        country,
        parent_location,
        parent_location_id,
        company_name,
        line_business,
        updated,
        id

    from source

)

select * from renamed
