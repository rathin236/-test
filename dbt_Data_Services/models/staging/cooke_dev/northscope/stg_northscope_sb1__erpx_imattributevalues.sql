with

source as (

    select * from {{ source('northscope_sb1', 'erpx_imattributevalues') }}

),

renamed as (

    select
        bw_item_id,
        dataentitycompanysk,
        raw_material_source,
        other,
        shell,
        specie,
        sub_species,
        category,
        trim,
        package_weight,
        navision_item__,
        selling_destination,
        finished_form,
        certification,
        cook,
        head,
        subdivision,
        case_weight,
        skin_cut,
        default_unit_uom,
        species,
        size,
        form,
        private_label,
        default_weight_uom,
        default_price_uom,
        grade,
        shrimp_category,
        tail,
        peeled,
        flavour,
        package_unit_count,
        product_size,
        industry_type,
        total_unit_count,
        frozen_format,
        high_level_category,
        process_type,
        country_of_origin,
        division,
        sliced,
        deveined,
        skinned,
        brand,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
