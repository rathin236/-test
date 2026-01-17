with

source as (

    select * from {{ source('timesheet', 'maintenance') }}

),

renamed as (

    select
        json_data,
        created_date,
        executionid

    from source

)

select * from renamed
