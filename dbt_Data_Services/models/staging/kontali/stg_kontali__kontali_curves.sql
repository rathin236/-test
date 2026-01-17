with

source as (

    select * from {{ source('kontali', 'kontali_curves') }}

),

renamed as (

    select
        id,
        "Curve_Name",
        curve_category

    from source

)

select * from renamed
