with

source as (

    select * from {{ source('monday', 'item_subscriber') }}

),

renamed as (

    select
        board_id,
        item_id,
        id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
