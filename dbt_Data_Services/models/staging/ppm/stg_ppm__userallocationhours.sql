with

source as (

    select * from {{ source('ppm', 'userallocationhours') }}

),

renamed as (

    select
        json_data,
        start_date,
        end_date,
        create_date,
        modified_date,
        executionid,
        allocation_id,
        status,
        row_number() over (partition by allocation_id order by modified_date desc) as rn
    from source
    qualify rn = 1

)

select * from renamed
