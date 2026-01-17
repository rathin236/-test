with

source as (

    select * from {{ source('ppm', 'resourcecapacity') }}

),

renamed as (

    select
        resource_id,
        json_data,
        start_date,
        end_date,
        create_date,
        modified_date,
        executionid,
        status

    from source

)

select * from renamed
