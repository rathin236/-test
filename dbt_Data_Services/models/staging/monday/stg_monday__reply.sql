with

source as (

    select * from {{ source('monday', 'reply') }}

),

renamed as (

    select
        update_id,
        id,
        text_body,
        updated_at,
        creator_id,
        body,
        _fivetran_deleted,
        _fivetran_synced,
        created_at

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
