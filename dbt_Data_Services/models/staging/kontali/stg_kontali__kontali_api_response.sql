with

source as (

    select * from {{ source('kontali', 'kontali_api_response') }}

),

renamed as (

    select
        "Curve_Name",
        "Start_date",
        "End_Date",
        json_data,
        category,
        timeseries_type,
        lastupdatedate,
        executionid

    from source

)

select * from renamed
