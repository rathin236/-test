with source as (

    select * from {{ source('ifs_prod_omeg1app', 'document_text_tab') }}

),

renamed as (

    select
        note_id,
        output_type,
        rowversion,
        note_text,
        rowkey,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
