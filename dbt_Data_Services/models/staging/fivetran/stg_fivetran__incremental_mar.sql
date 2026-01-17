with source as (

    select * from {{ source('fivetran', 'incremental_mar') }}

),

renamed as (

    select
        connector_id,
        destination_id,
        free_type,
        measured_date,
        schema_name,
        sync_type,
        table_name,
        updated_at,
        incremental_rows,
        _fivetran_synced

    from source

)

select * from renamed
