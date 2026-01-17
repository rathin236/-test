with source as (

    select * from {{ source('caglp_dbo', 'pop30300') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
