with

source as (

    select * from {{ source('ppm', 'entity_task') }}

),

renamed as (

    select
        entity_id,
        entity_name,
        entity_typeid,
        project_id,
        json_data,
        transactionid,
        insert_date,
        modified_date

    from source

)

select * from renamed
