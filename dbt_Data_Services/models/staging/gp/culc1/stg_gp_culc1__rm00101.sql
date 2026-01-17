with source as (

    select * from {{ source('culc1_dbo', 'rm00101') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
