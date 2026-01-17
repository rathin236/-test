with

source as (

    select * from {{ source('ppm', 'entity_project') }}

),

renamed as (

    select
        entity_id,
        entity_name,
        json_data,
        transactionid,
        insert_date,
        modified_date,
        entity_typeid,
        status

    from source

)

select * from renamed
where entity_id not in (2746547837, 2751176923)
