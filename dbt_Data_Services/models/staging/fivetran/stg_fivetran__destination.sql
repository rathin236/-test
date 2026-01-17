with source as (

    select
        id,
        name,
        account_id,
        created_at,
        region,
        _fivetran_synced,
        is_active,
        type
    from {{ source('fivetran', 'destination') }}
    where is_active = 'true'

),

renamed as (

    select
        id,
        account_id,
        created_at,
        region,
        _fivetran_synced,
        name
    from source

)

select * from renamed
