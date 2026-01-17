with source as (

    select * from {{ source('fivetran', 'fivetran_audit') }}

),

renamed as (

    select
        id,
        message,
        update_started,
        update_id,
        -- schema,
        -- table,
        --start,
        done,
        rows_updated_or_inserted,
        status,
        progress,
        _fivetran_synced

    from source

)

select * from renamed
