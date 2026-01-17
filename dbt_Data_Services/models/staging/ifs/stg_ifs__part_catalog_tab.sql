with source as (

    select * from {{ source('ifs_prod_omeg1app', 'part_catalog_tab') }}

),

renamed as (

    select
        part_no,
        storage_depth_requirement,
        storage_volume_requirement,
        uom_for_volume_net,
        min_storage_temperature,
        multilevel_tracking,
        weight_net,
        condition_code_usage,
        storage_width_requirement,
        uom_for_weight,
        catch_unit_enabled,
        storage_height_requirement,
        part_main_group,
        freight_factor,
        rowkey,
        volume_net,
        lot_tracking_code,
        text_id_,
        capacity_req_group_id,
        stop_arrival_issued_serial,
        lot_quantity_rule,
        storage_weight_requirement,
        position_part,
        sup_warranty_id,
        uom_for_length,
        max_storage_temperature,
        eng_serial_tracking_code,
        serial_tracking_code,
        cust_warranty_id,
        description,
        rowversion,
        uom_for_temperature,
        info_text,
        uom_for_volume,
        allow_as_not_consumed,
        configurable,
        unit_code,
        max_storage_humidity,
        stop_new_serial_in_rma,
        sub_lot_rule,
        std_name_id,
        component_lot_rule,
        min_storage_humidity,
        capability_req_group_id,
        input_unit_meas_group_id,
        uom_for_weight_net,
        serial_rule,
        condition_req_group_id,
        receipt_issue_serial_track,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed
where coalesce(_fivetran_deleted, false) = false
