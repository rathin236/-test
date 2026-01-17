with

source as (

    select * from {{ source('monday', 'board_view') }}

),

renamed as (

    select
        id,
        name,
        settings_str,
        type,
        board_id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
