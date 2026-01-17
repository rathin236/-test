with source as (

    select * from {{ source('cpqln_dbo', 'ext01103') }}

),

renamed as (

    select
        extender_record_id,
        field_id,
        total,
        functamt,
        dex_row_id,
        _fivetran_deleted,
        _fivetran_synced
    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
