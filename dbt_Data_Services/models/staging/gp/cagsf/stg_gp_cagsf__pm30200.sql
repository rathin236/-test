with source as (

    select * from {{ source('cagsf_dbo', 'pm30200') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
