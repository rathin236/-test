with

source as (

    select * from {{ source('monday', 'person_team') }}

),

renamed as (

    select
        board_id,
        column_value_id,
        item_id,
        id,
        _fivetran_deleted,
        _fivetran_synced,
        kind

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
