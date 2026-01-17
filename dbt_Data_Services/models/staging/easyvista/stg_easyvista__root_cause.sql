with source as (

    select * from {{ source('easyvista', 'root_cause') }}

),

renamed as (

    select
        rootcause_id,
        rootcause_en,
        insert_date,
        modified_date

    from source

)

select * from renamed
