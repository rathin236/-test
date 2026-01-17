with

source as (

    select * from {{ source('concur', 'user') }}

),

renamed as (

    select
        first_name,
        last_name,
        middle_name,
        primary_email,
        active,
        cell_phone_number,
        id,
        cost_center,
        employee_id,
        _fivetran_synced

    from source

)

select * from renamed
