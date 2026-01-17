with source as (

    select * from {{ source('hpi_dbo', 'pop30300') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
