with

source as (

    select * from {{ source('ppm', 'demandcapacity') }}

),

renamed as (

    select
        allocation_roleid,
        json_data,
        start_date,
        end_date,
        create_date,
        modified_date,
        executionid,
        status

    from source
    where status <> 'Inactive'
)

select * from renamed
where status = 'Active'
