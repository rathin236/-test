with

source as (

    select * from {{ source('innova_fbdag', 'qcs_dataaggimages') }}

),

renamed as (

    select
        id,
        image2dname,
        image3dname,
        dataagg,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
