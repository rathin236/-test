with

source as (

    select * from {{ source('ppm', 'timesheetforuser') }}

),

renamed as (

    select
        resource_id,
        json_data,
        start_date,
        end_date,
        status,
        timesheet_id,
        create_date,
        modified_date,
        executionid

    from source

)

select * from renamed
