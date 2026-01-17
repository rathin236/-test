with source as (

    select * from {{ source('nb678_dbo', 'pop30300') }}

),

renamed as (

    select * from source

)

select * from renamed
