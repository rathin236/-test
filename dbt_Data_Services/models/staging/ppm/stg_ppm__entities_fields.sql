with

source as (

    select * from {{ source('ppm', 'entities_fields') }}

),

renamed as (

    select
        entity_name,
        json_data,
        transactionid,
        insert_date,
        modified_date

    from source

)

select * from renamed
