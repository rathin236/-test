with source as (

    select * from {{ source('rbf_dbo', 'rm10101') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
