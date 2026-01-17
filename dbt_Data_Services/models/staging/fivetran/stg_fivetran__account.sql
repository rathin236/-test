with source as (

    select * from {{ source('fivetran', 'account') }}

),

renamed as (

    select
        id,
        name,
        created_at,
        status,
        country,
        _fivetran_synced

    from source

)

select * from renamed
