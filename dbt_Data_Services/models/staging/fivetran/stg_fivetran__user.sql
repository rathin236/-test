with source as (

    select * from {{ source('fivetran', 'user') }}

),

renamed as (

    select
        id,
        given_name,
        family_name,
        email,
        email_disabled,
        verified,
        created_at,
        phone,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
