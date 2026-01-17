with source as (

    select * from {{ source('ifs_prod_omeg1app', 'company_tab') }}

),

renamed as (

    select
        company,
        party,
        activity_start_date,
        domain_id,
        default_domain,
        auth_id_expire_date,
        default_language,
        party_type,
        country,
        from_template_id,
        rowversion,
        identifier_reference,
        creation_parameters,
        template_company,
        from_company,
        authorization_id,
        created_by,
        association_no,
        doc_recip_address_pos,
        creation_date,
        rowkey,
        logotype,
        name,
        identifier_ref_validation,
        print_senders_address,
        corporate_form,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
