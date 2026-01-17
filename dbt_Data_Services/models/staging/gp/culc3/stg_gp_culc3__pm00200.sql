with source as (

    select * from {{ source('culc3_dbo', 'pm00200') }}

),

renamed as (

    select * from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
