with

source as (

    select * from {{ source('monday', 'columns') }}

),

renamed as (

    select
        board_id,
        id,
        archived,
        settings_str,
        title,
        description,
        type,
        width,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
