with

source as (

    select * from {{ source('monday', 'activity_log') }}

),

renamed as (

    select
        board_id,
        id,
        account_id,
        created_at,
        data,
        entity,
        event,
        user_id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
