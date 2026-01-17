with

source as (

    select * from {{ source('monday', 'groups') }}

),

renamed as (

    select
        board_id,
        id,
        archived,
        color,
        deleted,
        position,
        title,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
