with

source as (

    select * from {{ source('monday', 'asset') }}

),

renamed as (

    select
        updates_id,
        id,
        url,
        file_size,
        url_thumbnail,
        uploaded_by_id,
        public_url,
        name,
        created_at,
        file_extension,
        _fivetran_deleted,
        _fivetran_synced

    from source
    where coalesce(_fivetran_deleted, 'false') = 'false'

)

select * from renamed
