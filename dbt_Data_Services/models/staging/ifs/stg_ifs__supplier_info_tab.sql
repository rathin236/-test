with source as (

    select * from {{ source('ifs_prod_omeg1app', 'supplier_info_tab') }}

),

renamed as (

    select
        supplier_id,
        party,
        association_no,
        creation_date,
        default_domain,
        rowkey,
        suppliers_own_id,
        name,
        text_id_,
        default_language,
        party_type,
        country,
        rowversion,
        identifier_reference,
        identifier_ref_validation,
        picture_id,
        corporate_form,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
