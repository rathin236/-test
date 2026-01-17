with

source as (

    select * from {{ source('monday', 'column_value_mirror_item') }}

),

renamed as (

    select
        column_value_id,
        item_id,
        id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
