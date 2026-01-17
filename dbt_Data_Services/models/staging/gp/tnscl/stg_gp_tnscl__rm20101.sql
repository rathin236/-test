with source as (

    select * from {{ source('tnscl_dbo', 'rm20101') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
