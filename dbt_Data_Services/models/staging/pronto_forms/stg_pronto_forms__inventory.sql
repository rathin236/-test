with

source as (

    select * from {{ source('pronto_forms', 'inventory') }}

),

renamed as (

    select
        json_data,
        form_name,
        created_date,
        executionid

    from source

)

select * from renamed
