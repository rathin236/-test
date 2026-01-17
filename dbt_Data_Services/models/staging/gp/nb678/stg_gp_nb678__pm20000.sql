with source as (

    select * from {{ source('nb678_dbo', 'pm20000') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
