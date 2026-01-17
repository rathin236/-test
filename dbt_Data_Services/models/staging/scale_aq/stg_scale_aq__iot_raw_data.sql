with

source as (

    select * from {{ source('feeddata', 'iot_raw_data') }}

),

renamed as (

    select
        json_data,
        start_date,
        end_date,
        created_date,
        modified_date,
        executionid

    from source

)

select * from renamed
