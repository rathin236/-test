with

source as (

    select * from {{ source('monday', 'team') }}

),

renamed as (

    select
        id,
        name,
        picture_url,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
