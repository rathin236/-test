with source as (

    select * from {{ source('ifs_prod_omeg1app', 'supplier_info_address_tab') }}

),

renamed as (

    select
        address_id,
        supplier_id,
        party,
        zip_code,
        default_domain,
        state,
        rowkey,
        ean_location,
        valid_to,
        party_type,
        country,
        city,
        rowversion,
        address,
        valid_from,
        address1,
        address2,
        county,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
