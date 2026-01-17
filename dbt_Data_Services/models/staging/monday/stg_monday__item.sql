with

source as (

    select * from {{ source('monday', 'item') }}

),

renamed as (

    select
        board_id,
        id,
        parent_item_id,
        group_id,
        email,
        name,
        updated_at,
        state,
        created_at,
        creator_id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
