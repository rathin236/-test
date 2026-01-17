with source as (

    select * from {{ source('fivetran', 'connector') }}

),

renamed as (

    select
        connector_id,
        connecting_user_id,
        connector_type_id,
        connector_name,
        paused,
        sync_frequency,
        _fivetran_deleted,
        destination_id,
        _fivetran_synced,
        date(signed_up) as connector_created_date

    from source

)

select * from renamed
