with

source as (

    select * from {{ source('monday', 'workspace') }}

),

renamed as (

    select
        id,
        created_at,
        name,
        kind,
        description,
        state,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
