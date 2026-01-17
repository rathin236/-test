with

source as (

    select * from {{ source('monday', 'updates') }}

),

renamed as (

    select
        id,
        body,
        created_at,
        creator_id,
        item_id,
        text_body,
        updated_at,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
