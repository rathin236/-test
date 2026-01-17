with

source as (

    select * from {{ source('monday', 'board_update') }}

),

renamed as (

    select
        board_id,
        id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
