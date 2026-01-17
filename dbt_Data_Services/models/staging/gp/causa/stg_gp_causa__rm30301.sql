with source as (

    select * from {{ source('causa_dbo', 'rm30301') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
