with source as (

    select * from {{ source('easyvista', 'urgency') }}

),

renamed as (

    select
        urgency_id,
        urgency_en,
        urgency_fr,
        insert_date,
        modified_date

    from source

)

select * from renamed
