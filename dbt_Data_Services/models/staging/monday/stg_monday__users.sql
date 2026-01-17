with

source as (

    select * from {{ source('monday', 'users') }}

),

renamed as (

    select
        id,
        photo_tiny,
        is_guest,
        url,
        photo_small,
        photo_thumb,
        is_admin,
        birthday,
        is_verified,
        enabled,
        email,
        utc_hours_diff,
        country_code,
        name,
        is_view_only,
        photo_thumb_small,
        location,
        current_language,
        title,
        phone,
        mobile_phone,
        time_zone_identifier,
        photo_original,
        created_at,
        is_pending,
        account_id,
        encrypt_api_token,
        _fivetran_deleted,
        _fivetran_synced,
        join_date

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
