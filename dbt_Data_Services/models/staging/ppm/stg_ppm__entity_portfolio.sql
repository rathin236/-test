with

source as (

    select * from {{ source('ppm', 'entity_portfolio') }}

),

renamed as (

    select
        entity_id,
        entity_name,
        json_data,
        transactionid,
        insert_date,
        modified_date,
        entity_typeid

    from source

)

select * from renamed
