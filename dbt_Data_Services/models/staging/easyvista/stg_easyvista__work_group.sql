with source as (

    select * from {{ source('easyvista', 'work_group') }}

),

renamed as (

    select
        group_id,
        group_en,
        insert_date,
        modified_date

    from source

)

select * from renamed
