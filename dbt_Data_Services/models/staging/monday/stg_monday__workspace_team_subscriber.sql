with

source as (

    select * from {{ source('monday', 'workspace_team_subscriber') }}

),

renamed as (

    select
        workspace_id,
        team_id,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
