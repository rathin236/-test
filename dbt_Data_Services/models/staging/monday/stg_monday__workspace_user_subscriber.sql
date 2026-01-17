with

source as (

    select * from {{ source('monday', 'workspace_user_subscriber') }}

),

renamed as (

    select
        workspace_id,
        user_id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
