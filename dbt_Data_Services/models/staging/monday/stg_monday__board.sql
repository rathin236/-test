with

source as (

    select * from {{ source('monday', 'board') }}

),

renamed as (

    select
        id,
        items_count,
        owner_id,
        board_folder_id,
        name,
        workspace_id,
        updated_at,
        permission,
        top_group_id,
        type,
        state,
        board_kind,
        description,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
