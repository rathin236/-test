with source as (

    select * from {{ source('fivetran', 'connector_type') }}

),

renamed as (

    select
        id,
        official_connector_name,
        type,
        availability,
        created_at,
        public_beta_at,
        release_at,
        deleted,
        broken,
        _fivetran_synced

    from source

)

select * from renamed
