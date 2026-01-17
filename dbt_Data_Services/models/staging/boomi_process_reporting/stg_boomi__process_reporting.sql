with source as (

    select * from {{ source('boomi', 'process_reporting') }}

),

renamed as (

    select
        json_data,
        insert_date,
        start_date,
        end_date

    from source

)

select * from renamed
