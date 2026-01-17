with source as (

    select * from {{ source('easyvista', 'impacts') }}

),

renamed as (

    select
        impact_id,
        impact_en,
        impact_fr,
        insert_date,
        modified_date

    from source

)

select * from renamed
