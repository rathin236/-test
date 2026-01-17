with

source as (

    select * from {{ source('monday', 'tags') }}

),

renamed as (

    select
        id,
        color,
        name,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
